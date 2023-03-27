import os
import shared
import environment
import validators
import arguments

def main():    
    # parse passed in arguments
    args = arguments.parse_codegen_arguments()

    # validate environment variables
    validators.validate_environment(environment)

    # set directory to target directory
    os.chdir(environment.CURTAIN_WALL_ENVIRONMENT)

    # add core 
    shared.parse_core_files(None)

    # run argument functions
    args.func(args)

if __name__ == "__main__":
    main()