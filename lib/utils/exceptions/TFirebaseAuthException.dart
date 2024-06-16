class TFirebaseAuthException implements Exception {
  final String code;

  TFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'El correo electrónico ya está registrado. Por favor utilice un correo electrónico diferente.';
      case 'invalid-email':
        return 'El correo electrónico proporcionado no es válido. Por favor introduzca un correo electrónico válido.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Elija una contraseña más segura.';
      case 'user-not-found':
        return 'Detalles de acceso incorrectos. Usuario no encontrado.';
      case 'invalid-verfication-code':
        return 'Código de verificación no válido. Por favor ingrese un código válido.';
      case 'quote-exceeded':
        return 'Por favor, inténtelo de nuevo más tarde';
      case 'email-already-exist':
        return 'Ya existe el correo electrónico. Por favor use un correo electrónico diferente.';
      case 'provider-already-linked':
        return 'Ya existe el correo electrónico. Por favor use un correo electrónico diferente.';
      default:
        return 'Problemas de autenticación. Intenta nuevamente';
    }
  }
}