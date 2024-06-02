
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
       UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
       return authResult.user;
    } catch(e) {
      print(e.toString());
    }
    return null;
  }

  Future signUp(String name, String email, String password) async {
    // try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return authResult.user;
    // } catch(e) {
    //   print(e.toString());
    // }
  }


  Future<void> signOut() async {
    try {
      return _auth.signOut();
    } catch(e) {
      print(e.toString());
    }
  }


  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
}