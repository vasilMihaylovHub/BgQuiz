
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_maker/common/constants.dart';
import '';

class AuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
       UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
       return authResult.user;
    } catch(e) {
      print(e.toString());
    }
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



















  // Mopped db
  final Map<String, Map<String, String>> _users = {};

  Future<String> signUpMopped(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: Constants.databaseResponseTimeSeconds)); // Simulating a network delay
    if (_users.containsKey(email)) {
      return 'Email is already registered';
    }
    _users[email] = {
      'name': name,
      'password': password,
    };
    return 'Signup successful';
  }

  Future<String> signInLocal(String email, String password) async {
    print('Try to login, email: $email');
    await Future.delayed(const Duration(seconds: Constants.databaseResponseTimeSeconds)); // Simulating a network delay
    if (!_users.containsKey(email)) {
      return 'Email not registered';
    }
    if (_users[email]!['password'] != password) {
      return 'Incorrect password';
    }
    return 'Login successful';
  }
}