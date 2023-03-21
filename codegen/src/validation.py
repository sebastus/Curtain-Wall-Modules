import inquirer 
import os

def validate_environment(environment):
   if (environment.CURTAIN_WALL_MODULES_HOME == None):
        print("CURTAIN_WALL_MODULES_HOME env var must be set to the location of the CW modules.")
        exit()

   bastion = f'{environment.CURTAIN_WALL_MODULES_HOME}/bastion'
   cw_modules_exists = os.path.isdir(bastion)
   if (cw_modules_exists):
      print('Detected Curtain Wall modules.')
   else:
      print('Please ensure that the modules repo is cloned into CURTAIN_WALL_MODULES_HOME.')
      exit()

   if (environment.CURTAIN_WALL_BACKEND_KEY == None):
      print('The backend key must be specified in env var CURTAIN_WALL_BACKEND_KEY.')
      exit()

   if (not os.path.isdir(environment.CURTAIN_WALL_ENVIRONMENT)):
      print(f'The name of the environment folder must be specified in env var CURTAIN_WALL_ENVIRONMENT.')
      exit()

def validation_number(answers, current):
   if not current.isdigit():
      raise inquirer.errors.ValidationError('', reason='Please enter a valid integer')

   return True

def validation_bool(answers, current):
   if current != 'true' and current != 'false':
      raise inquirer.errors.ValidationError('', reason='Please enter a valid boolean (true/false)')

   return True