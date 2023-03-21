import os
import shared
import environment
import validation
import arguments

def main():    
    # parse passed in arguments
    args = arguments.parse_arguments()

    # validate environment variables
    validation.validate_environment(environment)

    # set directory to target directory
    os.chdir(environment.CURTAIN_WALL_ENVIRONMENT)

    # add core 
    shared.parse_core_files()

    # run argument functions
    args.func(args)

if __name__ == "__main__":
    main()