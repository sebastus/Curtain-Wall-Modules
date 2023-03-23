import os
import shared
import environment
import validators

def main():
    # validate environment variables
    validators.validate_environment(environment)

    # set directory to target directory
    os.chdir(environment.CURTAIN_WALL_ENVIRONMENT)

    # add core 
    shared.parse_core_files()

    # get builder
    builder = shared.get_builder()

    # validate builder
    validators.validate_builder(builder)

    # add trust group and modules
    for trust_group in builder.get('trust_groups'):
        shared.add_trust_group(trust_group.get('name'), trust_group.get('variables')) 
        for module in trust_group.get('modules'):
            shared.add_module_to_trust_group(module.get('name'), module.get('index'), trust_group.get('name'), module.get('variables'))

if __name__ == "__main__":
    main()