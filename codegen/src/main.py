import os
import argparse 
from argparse import RawTextHelpFormatter
import atexit
import json
import uuid
import shutil

PIPELINE_TF_PLAN_FILE_NAME = "pl_tf_plan.yaml"
PIPELINE_TF_APPLY_FILE_NAME = "pl_tf_apply.yaml"
PIPELINE_TF_VARS_FILE_NAME = "pl_template.tfvars"
PIPELINE_VARIABLES_FILE_NAME = "pl_variables.yaml"
DOTENV_POSH_FILE_NAME = ".env.ps1"
DOTENV_BASH_FILE_NAME = ".env"
TFVARS_FILE_NAME = "dev.tfvars"

module_choices = [
    'aks',
    'bastion',
    'vhd-or-image',
    'vm-from-image-linux',
    'vm-from-image-windows',
    'azdo-server',
    "emulated-ash"
]

cwd = os.getcwd()
print("")   # blank line

def exiting_the_program():
    os.system("terraform fmt")
    if os.path.isfile(PIPELINE_TF_VARS_FILE_NAME):
        os.rename(PIPELINE_TF_VARS_FILE_NAME, 'pl.tfvars.tmpl')
    os.chdir(cwd)
    print("")

atexit.register(exiting_the_program)

# the folder containing the curtain wall modules repo
CURTAIN_WALL_MODULES_HOME = os.environ.get('CURTAIN_WALL_MODULES_HOME')

# the folder where resource groups and modules invocations should be placed
CURTAIN_WALL_ENVIRONMENT = os.environ.get('CURTAIN_WALL_ENVIRONMENT')

# the name of the tfstate file in azurerm backend remote storage
CURTAIN_WALL_BACKEND_KEY = os.environ.get('CURTAIN_WALL_BACKEND_KEY')

def get_module_schema(add):

    with open(f'{CURTAIN_WALL_MODULES_HOME}/{add}/metadata/schema.json',"r") as f:
        schema = json.load(f)

    return(schema)

def get_module_invocation_code(resource_group, add, index):

    with open(f'{CURTAIN_WALL_MODULES_HOME}/{add}/metadata/invoke.template.tf',"r") as f:
        lines = f.readlines()

    code = ""
    for line in lines:
        if index != None and line.find('xxx_') >= 0:
            line = line.strip('\n') + f'_{index}' + '\n'
        code += line.replace('xxx', f'{resource_group}')

    return(code)

def get_module_variable_group_code(resource_group, add, index):

    with open(f'{CURTAIN_WALL_MODULES_HOME}/{add}/metadata/variable-group.template.tf',"r") as f:
        lines = f.readlines()

    code = ""
    for line in lines:
        if index != None and line.find('xxx_') >= 0:
            line = line.strip('\n') + f'_{index}' + '\n'
        code += line.replace('xxx', f'{resource_group}')

    return(code)

def get_module_outputs_code(resource_group, add):

    file_name = f'{CURTAIN_WALL_MODULES_HOME}/{add}/metadata/outputs.template.tf'
    if (not os.path.isfile(file_name)):
        return("")

    with open(file_name,"r") as f:
        lines = f.readlines()

    code = ""
    for line in lines:
        code += line.replace('xxx', f'{resource_group}')

    return(code)

def get_complex_vars_code(resource_group, add):
    
    file_name = f'{CURTAIN_WALL_MODULES_HOME}/{add}/metadata/complex-vars.template.tf'
    if (not os.path.isfile(file_name)):
        return("")

    with open(file_name,"r") as f:
        lines = f.readlines()

    code = ""
    for line in lines:
        code += line.replace('xxx', f'{resource_group}')

    return(code)

def get_complex_tfvars_code(resource_group, add):

    file_name = f'{CURTAIN_WALL_MODULES_HOME}/{add}/metadata/complex-tfvars.template.tf'
    if (not os.path.isfile(file_name)):
        return("")

    with open(file_name,"r") as f:
        lines = f.readlines()

    code = ""
    for line in lines:
        code += line.replace('xxx', f'{resource_group}')

    return(code)

def init_terraform_yaml_files():

    in_file_name = f'{CURTAIN_WALL_MODULES_HOME}/remote/metadata/{PIPELINE_TF_PLAN_FILE_NAME}'
    out_file_name = f'{PIPELINE_TF_PLAN_FILE_NAME}'
    shutil.copy(in_file_name, out_file_name)

    in_file_name = f'{CURTAIN_WALL_MODULES_HOME}/remote/metadata/{PIPELINE_TF_APPLY_FILE_NAME}'
    out_file_name = f'{PIPELINE_TF_APPLY_FILE_NAME}'
    shutil.copy(in_file_name, out_file_name)



def write_outputs_file(resource_group, module_id, add):

    with open('outputs.tf', "a" if os.path.isfile('outputs.tf') else "w") as f:

        f.write('\n\n')
        f.write('# ############################\n')
        f.write(f'# Resource group: {resource_group}\n')
        if add != None:
            f.write(f'# Module name: {add}\n')
        f.write(f'# Instance ID: {module_id}\n')
        f.write('# ############################\n')

        f.write(get_module_outputs_code(resource_group, add if add!=None else "resource-group"))

        f.write('# ############################\n')
        f.write(f'# END: {module_id}\n')
        f.write('# ############################\n')

def write_invocation_file(resource_group, file_name, module_id, add, index, append):

    with open(file_name, "a" if append else "w") as f:

        f.write('\n\n')
        f.write('# ############################\n')
        f.write(f'# Resource group: {resource_group}\n')
        if add != None:
            f.write(f'# Module name: {add}\n')
        f.write(f'# Instance ID: {module_id}\n')
        f.write('# ############################\n')

        f.write(get_module_invocation_code(resource_group, add if add!=None else "resource-group", index))

        f.write('# ############################\n')
        f.write(f'# END: {module_id}\n')
        f.write('# ############################\n')

def write_vars_file(resource_group, vars, file_name, module_id, add, index, append):

    with open(file_name, "a" if append else "w") as f:

        f.write('\n\n')
        f.write('# ############################\n')
        f.write(f'# Resource group: {resource_group}\n')
        if add != None:
            f.write(f'# Module name: {add}\n')
        f.write(f'# Instance ID: {module_id}\n')
        f.write('# ############################\n')
        for var in vars:

            if (var.get("skip", "false") == "true"):
                f.write("\n")

            index_snip = "" if (index == None) else f"_{index}"
            f.write(f'variable \"{resource_group}_{var["name"]}{index_snip}\" {{ \n')

            f.write(f'\tdescription = \"{var["description"]}\"\n')

            f.write(f'\ttype = {var["type"]}\n')

            if (var["type"] in ['string', 'list(string)']):
                f.write(f'\tdefault = \"{var["default"]}\"\n')
            else:
                f.write(f'\tdefault = {var["default"]}\n')

            f.write('}\n')

        f.write('\n')
        f.write(get_complex_vars_code(resource_group, add if add!=None else "resource-group"))

        f.write('# ############################\n')
        f.write(f'# END: {module_id}\n')
        f.write('# ############################\n')

def write_tfvars_file(vars, file_name, resource_group, add, index, module_id, core):

    with open(file_name, "w" if core else "a") as f:

        f.write('\n\n')
        f.write('# ############################\n')
        if core:
            f.write(f'# Core/global\n')
        else:
            f.write(f'# Resource group: {resource_group}\n')
        if add != None:
            f.write(f'# Module name: {add}\n')
        if not module_id == None:
            f.write(f'# Instance ID: {module_id}\n')
        f.write('# ############################\n')

        for var in vars:

            if (var["secret"] == "true"):
                continue
            
            if (var.get("skip", "false") == "true"):
                f.write("\n")

            index_snip = "" if (index == None) else f"_{index}"
            rg_snip = "" if resource_group == None else f'{resource_group}_'
            if (var["type"] == 'string'):
                f.write(f'{rg_snip}{var["name"]}{index_snip} = \"{var["default"]}\"\n')
            else:
                f.write(f'{rg_snip}{var["name"]}{index_snip} = {var["default"]}\n')

        if not resource_group == None:
            f.write('\n')
            f.write(get_complex_tfvars_code(resource_group, add if add!=None else "resource-group"))

        f.write('# ############################\n')
        if core:
            f.write(f'# END: Core/global\n')
        else:
            f.write(f'# END: {module_id}\n')
        f.write('# ############################\n')

def write_variable_group_file(resource_group, file_name, module_id, add, index, append):

    with open(file_name, "a" if append else "w") as f:

        f.write('\n\n')
        f.write('# ############################\n')
        f.write(f'# Resource group: {resource_group}\n')
        if add != None:
            f.write(f'# Module name: {add}\n')
        f.write(f'# Instance ID: {module_id}\n')
        f.write('# ############################\n')

        f.write(get_module_variable_group_code(resource_group, add if add!=None else "resource-group", index))

        f.write('# ############################\n')
        f.write(f'# END: {module_id}\n')
        f.write('# ############################\n')

def write_variable_group_file_locals(vars, file_name, resource_group, add, index, module_id):

    with open(file_name, "a") as f:
        f.write('\n\n')
        f.write('# ############################\n')
        f.write(f'# Resource group: {resource_group}\n')
        if add != None:
            f.write(f'# Module name: {add}\n')
        f.write(f'# Instance ID: {module_id}\n')
        f.write('# ############################\n')

        f.write('\n')
        f.write('locals {\n')
        f.write(f'\t{resource_group}_variables = {{\n')

        for var in vars:

            if (var.get("skip", "false") == "true"):
                f.write("\n")

            index_snip = "" if (index == None) else f"_{index}"

            f.write(f'\"{resource_group}_{var["name"]}{index_snip}\" = {{\n')

            if (var["secret"] == "true"):
                f.write(f'secret_value = var.{resource_group}_{var["name"]}{index_snip} \n')
                f.write(f'value = \"\" \n')
            else:
                f.write(f'secret_value = \"\" \n')
                f.write(f'value = var.{resource_group}_{var["name"]}{index_snip} \n')

            f.write(f'is_secret = {var["secret"]}\n')
            f.write(f'}},\n')

        f.write(f'\t}}\n')
        f.write('}\n')

        f.write('# ############################\n')
        f.write(f'# END: {module_id}\n')
        f.write('# ############################\n')

def write_pipeline_tfvars_template(vars, resource_group, append):

    core_schema = get_module_schema("remote")
    core_vars = core_schema['variables']

    with open(f"{PIPELINE_TF_VARS_FILE_NAME}", "a" if append else "w") as f:
        f.write('# ############################\n')
        f.write("# Global/core non-secret variables\n")
        f.write('# ############################\n')

        for var in core_vars:

            # secrets don't go in tfvars
            if (var["secret"] == "true"):
                continue

            var_name = var["name"]
            f.write(f'{var_name} = \"${var_name.upper()}\"\n')

        f.write('\n\n')
        f.write('# ############################\n')
        f.write("# Non-secret variables for the module\n")
        f.write('# ############################\n')
        
        for var in vars:

            # secrets don't go in tfvars
            if (var["secret"] == "true"):
                continue

            var_name = var["name"]
            f.write(f'{resource_group}_{var_name} = \"${resource_group.upper()}_{var_name.upper()}\"\n')

def write_variables_yaml_file(backend_key, abs_environment, resource_group):

    file_exists = os.path.isfile(PIPELINE_VARIABLES_FILE_NAME)

    environment = os.path.basename(abs_environment)

    with open(PIPELINE_VARIABLES_FILE_NAME, "a" if file_exists else "w") as f:

        if not file_exists:
            f.write("variables:\n")

        if (resource_group == None):
            f.write(f'- group: {backend_key}__tfcreds\n')
            f.write(f'- group: {backend_key}__tfstate_backend\n')
            f.write(f'- group: {backend_key}__{environment}__core\n')
        else:
            f.write(f'- group: {backend_key}__{environment}__{resource_group}\n')

def write_terraform_plan_yaml_file(vars):

    core_schema = get_module_schema("remote")
    core_vars = core_schema['variables']

    with open(f"{PIPELINE_TF_PLAN_FILE_NAME}", "a") as f:
        write_banner(f, 'Global/core secret variables', None, None)

        for var in core_vars:

            # non-secrets don't go in terraform plan
            if (var["secret"] == "false"):
                continue

            var_name = var["name"]
            f.write(f'    TF_VAR_{var_name}: \"$({var_name.upper()})\"\n')

        f.write('\n')
        write_banner(f, 'Secret variables for the module', None, None)
        
        for var in vars:

            # non-secrets don't go in terraform plan
            if (var["secret"] == "false"):
                continue

            var_name = var["name"]
            f.write(f'    TF_VAR_{var_name}: \"$({var_name.upper()})\"\n')

def write_banner(file, banner, resource_group, module):
    
    file.write('# ############################\n')

    if resource_group != None:
        file.write(f'# Resource group: {resource_group}\n')        

    if module != None:
        file.write(f'# Module: {module}\n')        

    file.write(f"# {banner}\n")
    file.write('# ############################\n')

def write_dotenv_file(file_name, resource_group, index, vars, banner, format):

    file_exists = os.path.isfile(file_name)
    banner_written = False

    with open(file_name, "a" if file_exists else "w") as f:
        
        for var in vars:

            # non-secrets don't go in .env
            if (var["secret"] == "false"):
                continue

            if not banner_written:
                f.write('\n')
                write_banner(f, banner, None, None)
                banner_written = True

            var_name = var["name"]
            prefix = '' if format=='bash' else '$env:'
            rg_snip = '' if resource_group == None else f'{resource_group}_'
            index_snip = '' if index == None else f'_{index}'
            f.write(f'{prefix}TF_VAR_{rg_snip}{var_name}{index_snip}=\"changeme\"\n')

def write_dotenv_files(resource_group, index, vars, banner):
    write_dotenv_file(DOTENV_POSH_FILE_NAME, resource_group, index, vars, banner, 'powershell')
    write_dotenv_file(DOTENV_BASH_FILE_NAME, resource_group, index, vars, banner, 'bash')
    
def add_resource_group(args):

    fileset_exists = os.path.isfile(f'{args.g}.tf')
    if fileset_exists:
        print('Resource group already exists.')
        exit(0)

    print(f'Adding resource group {args.g}')

    schema = get_module_schema("resource-group")
    vars = schema['variables']

    module_id = uuid.uuid4()

    # write the xxx.tf file
    write_invocation_file(args.g, f'{args.g}.tf', module_id, None, None, False)

    # write the xxx_vars.tf file
    write_vars_file(args.g, vars, f'{args.g}_vars.tf', module_id, None, None, False)

    # write xxx.auto.tfvars file
    write_tfvars_file(vars, TFVARS_FILE_NAME, args.g, None, None, module_id, False)

    # write the outputs file
    write_outputs_file(args.g, module_id, None)

    # write the .env files
    write_dotenv_files(args.g, None, vars, 'Secret variables for the module')


def add_module_to_resource_group(args):

    fileset_exists = os.path.isfile(f'{args.g}.tf')
    if not fileset_exists:
        print('Resource group does not exist.')
        exit(0)

    print(f'Adding module {args.m}, to resource group {args.g}')
    schema = get_module_schema(args.m)

    vars = schema['variables']
    args.m_id = uuid.uuid4()

    # write the xxx.tf file
    write_invocation_file(args.g, f'{args.g}.tf', args.m_id, args.m, args.i, True)

    # write the xxx_vars.tf file
    write_vars_file(args.g, vars, f'{args.g}_vars.tf', args.m_id, args.m, args.i, True)

    # append to xxx.auto.tfvars file
    write_tfvars_file(vars, TFVARS_FILE_NAME, args.g, args.m, args.i, args.m_id, False)

    # write the outputs file
    write_outputs_file(args.g, args.m_id, args.m)

    # write the .env files
    write_dotenv_files(args.g, args.i, vars, 'Secret variables for the module')

def main():

    desc = 'Generate terraform code for your environment. Env vars to be set:\n\n'
    desc += 'CURTAIN_WALL_MODULES_HOME: absolute location of the modules repo\n'
    desc += 'CURTAIN_WALL_BACKEND_KEY: tfstate backend key for this environment\n'
    desc += 'CURTAIN_WALL_ENVIRONMENT: absolute location of the folder containing this environment\n'
    parser = argparse.ArgumentParser(
        description=desc,
        usage='python codegen\src\main.py ',
        formatter_class=RawTextHelpFormatter
    )

    subparsers = parser.add_subparsers(title = "Available commands", metavar='')

    add_parser = subparsers.add_parser('add', 
        help='Add a module to the given resource group.',
        description='Add a module to the given resource group.'
    )
    add_parser.add_argument('-g', 
        help = 'Base name of resource group to be added to the environment.',
        required = True,
        metavar='resource_group'
    )
    add_parser.add_argument('-m', 
        help = 'Name of module to be added.',
        required = True,
        metavar='module',
        choices=module_choices
    )
    add_parser.add_argument('-i', 
        required=False, 
        metavar='index',
        help='Index of the variable if multiple. 0,1,2...'
    )
    add_parser.set_defaults(func=add_module_to_resource_group)

    create_parser = subparsers.add_parser('create', 
        help='Create a new resource group.',
        description='Create a new resource group.'
    )
    create_parser.add_argument('-g', 
        required = True,
        help = 'Base name of resource group to which module will be added to the environment.',
        metavar='resource_group'
    )
    create_parser.set_defaults(func=add_resource_group)

    args = parser.parse_args()

    if (CURTAIN_WALL_MODULES_HOME == None):
        print("CURTAIN_WALL_MODULES_HOME env var must be set to the location of the CW modules.")
        exit()

    bastion = f'{CURTAIN_WALL_MODULES_HOME}/bastion'
    cw_modules_exists = os.path.isdir(bastion)
    if (cw_modules_exists):
        print('Detected Curtain Wall modules.')
    else:
        print('Please ensure that the modules repo is cloned into CURTAIN_WALL_MODULES_HOME.')
        exit()

    backend_key = ""
    if (CURTAIN_WALL_BACKEND_KEY != None):
        backend_key = CURTAIN_WALL_BACKEND_KEY
    if (backend_key == ""):
        print('The backend key must be specified in env var CURTAIN_WALL_BACKEND_KEY.')
        exit()

    environment = ""
    if (CURTAIN_WALL_ENVIRONMENT != None):
        environment = CURTAIN_WALL_ENVIRONMENT
    if (not os.path.isdir(environment)):
        print(f'The name of the environment folder must be specified in env var CURTAIN_WALL_ENVIRONMENT.')
        exit()
    os.chdir(environment)

    # this is done once per cw environment
    if (not os.path.isfile(f'{DOTENV_POSH_FILE_NAME}') and not os.path.isfile(f'{DOTENV_BASH_FILE_NAME}')):
        core_schema = get_module_schema("remote")
        core_vars = core_schema['variables']
        write_dotenv_files(None, None, core_vars, 'Global/core secret variables')
        write_tfvars_file(core_vars, TFVARS_FILE_NAME, None, None, None, None, True)

    args.func(args)

if __name__ == "__main__":
    main()