import inquirer
import os


def validate_environment(environment):
    if (environment.CURTAIN_WALL_MODULES_HOME == None):
        print("CURTAIN_WALL_MODULES_HOME env var must be set to the location of the CW modules.")
        exit()

    if (not os.path.isdir(f'{environment.CURTAIN_WALL_MODULES_HOME}/aks')):
        print(
            'Please ensure that the modules repo is cloned into CURTAIN_WALL_MODULES_HOME.')
        exit()

    if (not os.path.isdir(environment.CURTAIN_WALL_ENVIRONMENT)):
        print(f'The name of the environment folder must be specified in env var CURTAIN_WALL_ENVIRONMENT.')
        exit()


def validate_builder(builder):
    if (builder.get('trust_groups') == None):
        print('Trust groups must be specified.')
        exit()
    for trust_group in builder.get('trust_groups'):
        if (trust_group.get('name') == None):
            print('Trust group name must be specified.')
            exit()
        if (trust_group.get('modules') == None):
            print('Modules must be specified.')
            exit()
        for module in trust_group.get('modules'):
            if (module.get('name') == None):
                print('Module name must be specified.')
                exit()


def validation_number(answers, current):
    if not current.isdigit():
        raise inquirer.errors.ValidationError(
            '', reason='Please enter a valid integer')

    return True


def validation_bool(answers, current):
    if current != 'true' and current != 'false':
        raise inquirer.errors.ValidationError(
            '', reason='Please enter a valid boolean (true/false)')

    return True
