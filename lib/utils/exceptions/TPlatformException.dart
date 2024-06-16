class TPlatformException implements Exception{
  final String code;

  TPlatformException(this.code);

  String get message{
    switch(code){
      case 'INVALID_LOGIN_CREDENTIALS' :
        return 'Credenciales inválidas. Por favor revisar su información';
      case 'too-many-requests' :
        return 'Muchas solicitudes de petición. Por favor intenta más tarde';
      case 'invalid-argument' :
        return 'Argumento proveido inválido para el método de autenticación.';
      case 'invalid-password' :
        return 'Contraseña incorrecta. Por favor intentar nuevamente';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida. Contacta a soporte para asistencia';
      case 'session-cookie-expired' :
        return 'Las cookies de sesión ha sido expirada. Por favor inicia sesión nuevamente';
      case 'uid-already-exists' :
        return 'El ID de usuario es usado por otro usuario';
      case 'sign-in-failed' :
        return 'Inicio de sesión fallido. Intenta nuevamente';
      case 'network-request-failed' :
        return 'Por favor revisa tu conexión de internet';
      case 'internal-error' :
        return 'Ocurrió un problema en la autenticación interna. Inténtalo de nuevo.';
      case 'invalid-verification-code':
        return 'Código de verificación inválido. Por favor ingresar un código válido';
      case 'invalid-verification-id':
        return 'ID de verificación inválido. Por favor solicita un núevo código de verificación';
      default:
        return 'Error desconocido';
    }
  }

}