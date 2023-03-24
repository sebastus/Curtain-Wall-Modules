from io import TextIOWrapper
import os
import atexit
import json
import uuid
import inquirer
import validators
import environment
import constants

cwd = os.getcwd()

def exiting_the_program():
    os.system("terraform fmt")
    os.chdir(cwd)

atexit.register(exiting_the_program)

def get_builder():
    file_name = f'{environment.CURTAIN_WALL_MODULES_HOME}/codegen/src/builder.json'
    return(get_json_file(file_name))

def get_schema(name, schema):
    file_name = f'{environment.CURTAIN_WALL_MODULES_HOME}/{name}/metadata/{schema}.json'
    return(get_json_file(file_name))

def get_json_file(file_name):
    if (not os.path.isfile(file_name)):
        return()
    
    with open(file_name,"r") as f:
        file = json.load(f)

    return(file)

def parse_tf_file(trust_group, module, index, name):
    file_name = f'{environment.CURTAIN_WALL_MODULES_HOME}/{module}/metadata/{name}.template.tf'
    if (not os.path.isfile(file_name)):
        return("")
    
    with open(file_name,"r") as f:
        lines = f.readlines()

    code = ""
    for line in lines:
        if index != None and line.find('xxx_') >= 0:
            line = line.strip('\n') + f'_{index}' + '\n'
        code += line.replace('xxx', f'{trust_group}')

    return(code)

def get_value(var, vars, variable_values):
    is_used = evaluate_usage(var, vars)
    current_var =  next((sub for sub in vars if sub.get('name') == var.get('name')), None)

    if(current_var != None and current_var.get("value") != None):
        return current_var.get("value")
    elif (var.get("query") and is_used and environment.CURTAIN_WALL_USE_MLD):
        if(var.get("type") == "bool"):
            return inquirer.text(message=var.get("query"), default=var.get("default"), validate = validators.validation_bool)
        elif(var.get("type") == "number"):
            return inquirer.text(message=var.get("query"), default=var.get("default"), validate = validators.validation_number)
        else: 
            return inquirer.text(message=var.get("query"), default=var.get("default"))
    elif (variable_values != None and variable_values.get(var.get("name")) != None):
        return variable_values.get(var["name"])
    
    return var.get("default")

def write_outputs_file(trust_group, module_id, module):

    with open('outputs.tf', "a" if os.path.isfile('outputs.tf') else "w") as f:

        add_start(f, module_id, module, trust_group)

        f.write(parse_tf_file(trust_group, module if module!=None else "trust-group", None, "outputs"))

        add_end(f, module_id)

def write_invocation_file(trust_group, file_name, module_id, module, index, append):

    with open(file_name, "a" if append else "w") as f:

        add_start(f, module_id, module, trust_group)

        f.write(parse_tf_file(trust_group, module if module!=None else "trust-group", index, "invoke"))

        add_end(f, module_id)

def write_vars_file(trust_group, vars, file_name, module_id, module, index, append):

    with open(file_name, "a" if append else "w") as f:
        add_start(f, module_id, module, trust_group)

        for var in vars:

            if (var.get("skip", "false") == "true"):
                f.write("\n")

            index_snip = "" if (index == None) else f"_{index}"
            f.write(f'variable \"{trust_group}_{var["name"]}{index_snip}\" {{ \n')

            f.write(f'\tdescription = \"{var["description"]}\"\n')

            f.write(f'\ttype = {var["type"]}\n')

            if (var["type"] in ['string', 'list(string)']):
                f.write(f'\tdefault = \"{var["default"]}\"\n')
            else:
                f.write(f'\tdefault = {var["default"]}\n')

            f.write('}\n')

        f.write('\n')
        f.write(parse_tf_file(trust_group, module if module!=None else "trust-group", None, "complex-vars"))
        
        add_end(f, module_id)

def add_start(f: TextIOWrapper, module_id, module, trust_group):
    f.write('\n\n')
    f.write('# ############################\n')
    f.write(f'# Trust group: {trust_group}\n')
    if module != None:
        f.write(f'# Module name: {module}\n')
    f.write(f'# Instance ID: {module_id}\n')
    f.write('# ############################\n')

def add_end(f: TextIOWrapper, module_id):
    f.write('# ############################\n')
    f.write(f'# END: {module_id}\n')
    f.write('# ############################\n')

def evaluate_usage(variable, variables):
    if ("condition" in variable):
        expression = variable["condition"].split('?')[0].strip()
        terms = expression.split('==')
        parent_name = terms[0].strip()
        options = variable["condition"].split('?')[1].split(':')
                
        parent = next((sub for sub in variables if sub['name'] == parent_name), None)
        if(parent["value"] == "true"):
            option = options[0].strip()
        elif (len(terms) > 1 and parent["value"] == terms[1].strip().strip("'")):
            option = options[0].strip()
        else:
            option = options[1].strip()
        
        if(option == '0'):
            return(False)
    return(True)
                         
def write_tfvars_file(vars, file_name, trust_group, add, index, module_id, core, variable_values):

    with open(file_name, "w" if core else "a") as f:

        f.write('\n\n')
        f.write('# ############################\n')
        if core:
            f.write(f'# Core/global\n')
        else:
            f.write(f'# Trust group: {trust_group}\n')
        if add != None:
            f.write(f'# Module name: {add}\n')
        if not module_id == None:
            f.write(f'# Instance ID: {module_id}\n')
        f.write('# ############################\n')

        for var in vars:
            if (var["secret"] == "true"):
                continue
            
            var["value"] = get_value(var, vars, variable_values)

            if (var.get("skip", "false") == "true"):
                f.write("\n")

            index_snip = "" if (index == None) else f"_{index}"
            rg_snip = "" if trust_group == None else f'{trust_group}_'

            if (var["type"] == 'string'):
                f.write(f'{rg_snip}{var["name"]}{index_snip} = \"{var["value"]}\"\n')
            else:
                f.write(f'{rg_snip}{var["name"]}{index_snip} = {var["value"]}\n')

        if trust_group != None:
            f.write('\n')
            f.write(parse_tf_file(trust_group, add if add!=None else "trust-group", None, "complex-tfvars"))

        f.write('# ############################\n')
        if core:
            f.write(f'# END: Core/global\n')
        else:
            f.write(f'# END: {module_id}\n')
        f.write('# ############################\n')


def write_banner(file, banner, trust_group, module):
    
    file.write('# ############################\n')

    if trust_group != None:
        file.write(f'# Trust group: {trust_group}\n')        

    if module != None:
        file.write(f'# Module: {module}\n')        

    file.write(f"# {banner}\n")
    file.write('# ############################\n')

def write_dotenv_file(file_name, trust_group, index, vars, banner, format, variable_values):

    file_exists = os.path.isfile(file_name)
    banner_written = False

    with open(file_name, "a" if file_exists else "w") as f:
        
        for var in vars:

            # non-secrets don't go in .env
            if (var["secret"] == "false"):
                continue

            var["value"] = get_value(var, vars, variable_values)

            if not banner_written:
                f.write('\n')
                write_banner(f, banner, None, None)
                banner_written = True

            var_name = var["name"]
            prefix = '' if format=='bash' else '$env:'
            rg_snip = '' if trust_group == None else f'{trust_group}_'
            index_snip = '' if index == None else f'_{index}'

            if(var["value"] != var["default"]):
                f.write(f'{prefix}TF_VAR_{rg_snip}{var_name}{index_snip}=\"{var["value"]}\"\n')
            else:
                f.write(f'{prefix}TF_VAR_{rg_snip}{var_name}{index_snip}=\"changeme\"\n')

def write_dotenv_files(trust_group, index, vars, banner, variable_values):
    write_dotenv_file(constants.DOTENV_POSH_FILE_NAME, trust_group, index, vars, banner, 'powershell', variable_values)
    write_dotenv_file(constants.DOTENV_BASH_FILE_NAME, trust_group, index, vars, banner, 'bash', variable_values)

def add_trust_group(trust_group_name, variable_values):
    fileset_exists = os.path.isfile(f'{trust_group_name}.tf')
    if fileset_exists:
        print('trust group already exists.')
        return()

    print(f'Adding trust group {trust_group_name}')

    schema = get_schema("trust-group", "schema")
    vars = schema['variables']

    module_id = uuid.uuid4()

    # write the xxx.tf file
    write_invocation_file(trust_group_name, f'{trust_group_name}.tf', module_id, None, None, False)

    # write the xxx_vars.tf file
    write_vars_file(trust_group_name, vars, f'{trust_group_name}_vars.tf', module_id, None, None, False)

    # write xxx.auto.tfvars file
    write_tfvars_file(vars, constants.TFVARS_FILE_NAME, trust_group_name, None, None, module_id, False, variable_values)

    # write the outputs file
    write_outputs_file(trust_group_name, module_id, None)

    # write the .env files
    write_dotenv_files(trust_group_name, None, vars, 'Secret variables for the module', variable_values)
    
def add_module_to_trust_group(module_name, index, trust_group_name, variable_values):

    fileset_exists = os.path.isfile(f'{trust_group_name}.tf')
    if not fileset_exists:
        print('trust group does not exist.')
        return()

    print(f'Adding module {module_name}, to trust group {trust_group_name}')
    schema = get_schema(module_name, "schema")

    vars = schema['variables']
    module_id = uuid.uuid4()

    # write the xxx.tf file
    write_invocation_file(trust_group_name, f'{trust_group_name}.tf', module_id, module_name , index, True)

    # write the xxx_vars.tf file
    write_vars_file(trust_group_name, vars, f'{trust_group_name}_vars.tf', module_id, module_name, index, True)

    # append to xxx.auto.tfvars file
    write_tfvars_file(vars, constants.TFVARS_FILE_NAME, trust_group_name, module_name, index, module_id, False, variable_values)

    # write the outputs fil, variable_e
    write_outputs_file(trust_group_name, module_id, module_name)

    # write the .env files
    write_dotenv_files(trust_group_name, index, vars, 'Secret variables for the module', variable_values)

def parse_core_files():
    if (not os.path.isfile(f'{constants.DOTENV_POSH_FILE_NAME}') and not os.path.isfile(f'{constants.DOTENV_BASH_FILE_NAME}')):
        core_schema = get_schema("trust-group", "core-schema")
        core_vars = core_schema['variables']
        write_dotenv_files(None, None, core_vars, 'Global/core secret variables', None)
        write_tfvars_file(core_vars, constants.TFVARS_FILE_NAME, None, None, None, None, True, None)