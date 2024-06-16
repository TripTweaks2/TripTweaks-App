class TFacebookAuthException implements Exception {
  final String code;

  TFacebookAuthException(this.code);

  String get message {
    switch (code) {
      case 'CANCELLED':
        return 'Inicio de sesión cancelado por el usuario.';
      case 'FAILED':
        return 'Error en el inicio de sesión con Facebook.';
      case 'OPERATION_IN_PROGRESS':
        return 'Una operación de inicio de sesión ya está en progreso.';
      case 'ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return 'La cuenta ya existe con credenciales diferentes. Por favor use un método de inicio de sesión diferente.';
      case 'INVALID_CREDENTIAL':
        return 'Credenciales inválidas. Por favor, intente nuevamente.';
      default:
        return 'Error de autenticación con Facebook. Intenta nuevamente.';
    }
  }
}