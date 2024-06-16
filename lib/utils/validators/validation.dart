class Validator {
  ///Campo Vacio
  static String? validateEmptyText(String? fieldname,String? value){
    if(value== null || value.isEmpty){
      return'$fieldname es requerido';
    }
    return null;
  }


  static String? validateEmail(String? value){
    if(value == null || value.isEmpty){
      return 'Correo electrónico es requerido';
    }

    final emailRegExp=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if(!emailRegExp.hasMatch(value)){
      return 'Correo electrónico inválido';
    }

    return null;
  }

  static String? validatePassword(String? value){
    if(value==null || value.isEmpty){
      return 'Contraseña es requerido';
    }

    if(value.length < 6){
      return 'Contraseña debe de tener como mínimo 6 carácteres';
    }

    if(!value.contains(RegExp(r'[A-Z]'))){
      return 'Contraseña debe de contener como mínimo una mayúscula';
    }

    if(!value.contains(RegExp(r'[0-9]'))){
      return 'Contraseña debe de contener como mínimo un número';
    }

    if(!value.contains(RegExp(r'[!@#$>%^&*(),.?":{}|<>]'))){
      return 'Contraseña debe de contener como mínimo un carácter especial';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value){
    if(value==null || value.isEmpty){
      return 'Celular es requerido';
    }

    final phoneRegExp = RegExp(r'^\d{9}$');


    if(!phoneRegExp.hasMatch(value)){
      return 'Formato de celular inválido (9 dígitos requeridos)';
    }

    return null;
  }
}