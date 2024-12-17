import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  static final AuthService _instance = AuthService._internal();

  AuthService._internal();

  factory AuthService()
  {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      return result.user;
    }catch(e) {
      print('Error al registrarse: $e');
      return null;
    }
  }

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password);
      return result.user;
    }catch(e)
    {
      print('Error al iniciar sesion con usuario y contraseña: $e');
      return null;
    }
  }

  Future<User?> loginWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Si el usuario cancela el inicio de sesión
      if(googleUser == null) return null;
      // Obtener detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Crear credenciales para Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      // Iniciar sesión con las credenciales de Google en Firebase
      final UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    }catch(e)
    {
      print('Error al iniciar sesion con google: $e');
      return null;
    }
  }

  // Cerrar sesion
  Future<void> logout() async {
    try{
      await _auth.signOut();
      await _googleSignIn.signOut();
    }catch(e)
    {
      print('Error al cerrar sesión: $e');
    }
  }

  // Observar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}