import os
import shared
import environment
import validators
import arguments

def main():
    # validate environment variables
    validators.validate_environment(environment)

    args = arguments.parse_builder_arguments()

    # set directory to target directory
    os.chdir(environment.CURTAIN_WALL_ENVIRONMENT)

    # get builder
    name = args.f if args.f else 'builder'
    builder = shared.get_builder(name)

    # validate builder
    validators.validate_builder(builder)

    # add core 
    shared.parse_core_files(builder.get('variables'))

    # add trust group and modules
    for trust_group in builder.get('trust_groups'):
        shared.add_trust_group(trust_group.get('name'), trust_group.get('variables')) 
        for module in trust_group.get('modules'):
            shared.add_module_to_trust_group(module.get('name'), module.get('index'), trust_group.get('name'), module.get('variables'))

if __name__ == "__main__":
    main()