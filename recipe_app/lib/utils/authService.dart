import 'package:firebase_auth/firebase_auth.dart';
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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if(googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      final UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    }catch(e)
    {
      print('Error al iniciar sesion con google: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try{
      await _auth.signOut();
      await _googleSignIn.signOut();
    }catch(e)
    {
      print('Error al cerrar sesión: $e');
    }
  }
}