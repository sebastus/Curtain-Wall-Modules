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

    # add trust group and modules
    builder = shared.get_builder()

    # validate builder
    validators.validate_builder(builder)

    for trust_group in builder['trust_groups']:
        shared.add_trust_group(trust_group.get('name')) 
        for module in trust_group['modules']:
            shared.add_module_to_trust_group(module.get('name'), module.get('index'), trust_group.get('name'), module.get('variables'))

if __name__ == "__main__":
    main()