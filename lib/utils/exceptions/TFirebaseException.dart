class TFirebaseException implements Exception {
  final String code;

  TFirebaseException(this.code);

  String get message {
    switch (code) {
      case 'unknown':
        return 'Se produjo un error desconocido en la base de datos. Inténtalo de nuevo.';
      case 'invalid-custom-token':
        return 'El formato de token personalizado es inválido. Por favor revisar su token';
      case 'custom-token-mismatch':
        return 'El token personalizado corresponde a una cuenta diferente';
      case 'user-disabled':
        return 'La cuenta ha sido desactivada';
      case 'user-not-found':
        return 'Usuario no encontrado para el correo brindado';
      case 'invalid-email':
        return 'El correo electrónico proporcionado no es válido. Por favor introduzca un correo electrónico válido.';
      case 'email-already-in-use':
        return 'Ya existe el correo electrónico. Por favor use un correo electrónico diferente.';
      case 'wrong-password':
        return 'Contraseña incorrecta. Por favor revisa tu contraseña y vuelve a intentar';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Elija una contraseña más segura.';
      case 'provider-already-linked':
        return 'Ya existe el correo electrónico. Por favor use un correo electrónico diferente.';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida. Contacta a soporte para asistencia';
      case 'invalid-credential':
        return 'La credencial suministrada está mal escrita o ha sido expirada';
      case 'invalid-verification-code':
        return 'Código de verificación inválido. Por favor ingresar un código válido';
      case 'invalid-verification-id':
        return 'ID de verificación inválido. Por favor solicita un núevo código de verificación';
      case 'captcha-check-failed':
        return 'La respuesta reCAPTCHA es inválido. Por favor intenta de nuevo';
      case 'app-not-authorized':
        return 'La aplicación no está autorizada con el API Key proveida';
      case 'internal-error':
        return 'Ocurrió un problema en la autenticación. Inténtalo de nuevo.';
      default:
        return '';
    }
  }
}