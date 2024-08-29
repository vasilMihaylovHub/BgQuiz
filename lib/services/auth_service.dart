import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    UserCredential authResult = await authInstance.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult.user;
  }

  Future signUp(String email, String password) async {
    UserCredential authResult = await authInstance
        .createUserWithEmailAndPassword(email: email, password: password);
    return authResult.user;
  }

  Future<void> signOut() async {
    return authInstance.signOut();
  }

  Future<User?> getCurrentUser() async {
    return authInstance.currentUser;
  }
}
