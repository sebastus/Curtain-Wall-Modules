import os

CURTAIN_WALL_MODULES_HOME = os.getenv('CURTAIN_WALL_MODULES_HOME')
CURTAIN_WALL_ENVIRONMENT = os.getenv('CURTAIN_WALL_ENVIRONMENT')
CURTAIN_WALL_USE_MLD = (os.getenv('CURTAIN_WALL_USE_MLD', 'True') == 'True')
CURTAIN_WALL_VERBOSE_TFVARS = (os.getenv('CURTAIN_WALL_VERBOSE_TFVARS', 'False') == 'True')
