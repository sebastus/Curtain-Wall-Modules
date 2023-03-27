
import argparse 
from argparse import RawTextHelpFormatter
import shared

module_choices = [
    'aks',
    'bastion',
    'vhd-or-image',
    'vm-from-image-linux',
    'vm-from-image-windows',
    'azdo-server',
    'emulated-ash',
    'vmss-ba',
    'linux-vm',
    'aks-build-agent',
    'aks-nexus'
]

def parse_codegen_arguments():
    desc = 'Generate terraform code for your environment. Env vars to be set:\n\n'
    desc += 'CURTAIN_WALL_MODULES_HOME: absolute location of the modules repo\n'
    desc += 'CURTAIN_WALL_ENVIRONMENT: absolute location of the folder containing this environment\n'
    
    parser = argparse.ArgumentParser(
        description=desc,
        usage='python codegen\src\codegen.py ',
        formatter_class=RawTextHelpFormatter
    )

    subparsers = parser.add_subparsers(title = "Available commands", metavar='')

    add_parser = subparsers.add_parser('add', 
        help='Add a module to the given trust group.',
        description='Add a module to the given trust group.'
    )
    add_parser.add_argument('-g', 
        help = 'Base name of trust group to be added to the environment.',
        required = True,
        metavar='trust_group'
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
    add_parser.set_defaults(func=add_module_to_trust_group)

    create_parser = subparsers.add_parser('create', 
        help='Create a new trust group.',
        description='Create a new trust group.'
    )
    create_parser.add_argument('-g', 
        required = True,
        help = 'Base name of trust group to which module will be added to the environment.',
        metavar='trust_group'
    )
    create_parser.set_defaults(func=add_trust_group)

    return(parser.parse_args())

def parse_builder_arguments():
    desc = 'Generate terraform code for your environment. Env vars to be set:\n\n'
    desc += 'CURTAIN_WALL_MODULES_HOME: absolute location of the modules repo\n'
    desc += 'CURTAIN_WALL_ENVIRONMENT: absolute location of the folder containing this environment\n'
    
    parser = argparse.ArgumentParser(
        description=desc,
        usage='python codegen\src\builder.py ',
        formatter_class=RawTextHelpFormatter
    )

    parser.add_argument('-f', 
        required = False,
        help = 'File name of the builder file.',
        metavar='file'
    )

    return(parser.parse_args())

def add_trust_group(args):
    shared.add_trust_group(args.g, None)

def add_module_to_trust_group(args):
    shared.add_module_to_trust_group(args.m, args.i, args.g, None)