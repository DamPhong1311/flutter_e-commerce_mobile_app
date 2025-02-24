class VValidators {
 static String? validateEmptyText(String? fieldName, String? value){
  if(value == null || value.isEmpty){
    return '$fieldName is required';
  }
  return null;
 }  
  
 

  static String? validateEmail(String? value){
    if(value == null || value.isEmpty){
      return 'Email is required.';
    }

    final emailRegExp =  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if(!emailRegExp.hasMatch(value)){
      return 'Invalid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      return 'Password is required.';
    }
    // check length
    if(value.length<6){
      return 'Password must be  at least 6 characters long.';
   
    }
    // check uppercase letter
    if(!value.contains(RegExp(r'[A-Z]'))){
      return 'Password must contain at least one uppercase letter.';
    }
    // check numbers
    if(!value.contains(RegExp(r'[0-9]'))){
      return 'Password must contain at least one number.';
    }
    // check special chareacter
    if(!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      return 'Password must contain at least one special character.';
    }

    return null;

  }
}