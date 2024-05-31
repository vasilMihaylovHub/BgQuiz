
class AuthService {
  final Map<String, Map<String, String>> _users = {};

  var DB_TIME_SECONDS = 3;

  Future<String> signUp(String name, String email, String password) async {
    await Future.delayed(Duration(seconds: DB_TIME_SECONDS)); // Simulating a network delay
    if (_users.containsKey(email)) {
      return 'Email is already registered';
    }
    _users[email] = {
      'name': name,
      'password': password,
    };
    return 'Signup successful';
  }

  Future<String> signIn(String email, String password) async {
    print('Try to login, email: $email');
    await Future.delayed(Duration(seconds: DB_TIME_SECONDS)); // Simulating a network delay
    if (!_users.containsKey(email)) {
      return 'Email not registered';
    }
    if (_users[email]!['password'] != password) {
      return 'Incorrect password';
    }
    return 'Login successful';
  }
}