import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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


  signInWithGoogle() async {
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication auth = await account!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken
    );

     return await authInstance.signInWithCredential(credential);
  }

  Future<bool> resetPassword(String email) async {
    try {
       await authInstance.sendPasswordResetEmail(email: email);
       return Future.value(true);
    } on Exception catch (e){
      print( "[resetPassword] "+ e.toString());
      return Future.value(false);
    }
  }
}
