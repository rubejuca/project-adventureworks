// TODO Implement this library.
import 'dart:async';

class AuthResult {
  final bool ok;
  final String? message;

  const AuthResult({required this.ok, this.message});
}

class AuthService {
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isEmpty || password.isEmpty) {
      return const AuthResult(
        ok: false,
        message: 'Completa email y contraseña',
      );
    }
    if (password.length < 6) {
      return const AuthResult(
        ok: false,
        message: 'La contraseña debe tener al menos 6 caracteres',
      );
    }
    return const AuthResult(ok: true);
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
