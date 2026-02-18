import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }
}