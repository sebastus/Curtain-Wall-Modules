import inquirer 

def validation_number(answers, current):
   if not current.isdigit():
      raise inquirer.errors.ValidationError('', reason='Please enter a valid integer')

   return True

def validation_bool(answers, current):
   if current != 'true' and current != 'false':
      raise inquirer.errors.ValidationError('', reason='Please enter a valid boolean (true/false)')

   return True