// class Usuario {
//   String? _nome;
//   String? get nome => _nome;
//   set nome(String? nome){
//     _nome = nome;
//   }

//   String? _email;
//   String? get email => _email;
//   set email(String? email) {
//     _email = email;
//   }

//   Usuario(String? nome, String? email) {
//     _nome = nome;
//     _email = email;
//   }
// }

import 'package:agiledevs/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Autenticador {
  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();

  static Future<Usuario?> login() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return Usuario(googleUser.displayName, googleUser.email);

    } catch (erro) {
      print("Erro no login: $erro");
      return null;
    }
  }

  static Future<Usuario?> recuperarUsuario() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return Usuario(currentUser.displayName, currentUser.email);
    }
    return null;
  }

  static Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}