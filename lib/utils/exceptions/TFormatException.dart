class TFormatException implements Exception{
  final String message;

  const TFormatException([this.message = 'Se produjo un error de formato inesperado. Por favor revisar']);

  factory TFormatException.fromMessage(String message){
    return TFormatException(message);
  }


  String get formattedException => message;

  factory TFormatException.fromCode(String code){
    switch(code) {
      case 'invalid-email-format':
        return const TFormatException('El formato de correo electrónico es inválido. Por favor ingresar correo electrónico válido');
      case 'invalid-phone-number-format':
        return const TFormatException('El formato del celular brindado es inválido. Por favor ingresar número de celular válido');
      case 'invalid-date-format':
        return const TFormatException('El formato de fecha es inválido. Por favor ingresar fecha válida');
      case 'invalid-url-format':
        return const TFormatException('El formato de URL es inválido. Por favor ingresar URL válido');
      case 'invalid-numeric-format':
        return const TFormatException('El formato es numérico');
      default:
        return const TFormatException('Se produjo un error de formato inesperado. Por favor revisar');
    }
  }


}