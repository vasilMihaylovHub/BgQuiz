import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_maker/main.dart';

class AuthService {
  FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    logger.i("Try to signIn:  $email");
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
    logger.i("signing out...");
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
      logger.e( "[resetPassword] "+ e.toString());
      return Future.value(false);
    }
  }
}
