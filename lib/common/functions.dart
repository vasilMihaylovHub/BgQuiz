
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {

  static const String _userLoggedInKey = "USERLOGGEDINKEY";
  static const String _currUserEmail = "CURRUSEREMAIL";

  static saveCurrentUser({required bool isLoggedIn, String? email = null}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(isLoggedIn){
      prefs.setString(_currUserEmail, email!);
      prefs.setBool(_userLoggedInKey, isLoggedIn);
    } else {
      prefs.clear();
    }
  }

  static Future<Store> getCurrentUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Store(prefs.getString(_currUserEmail),
        prefs.getBool(_userLoggedInKey)
    );
  }
}

class Store extends Equatable {
  final String? email;
  final bool? isLogged;

  const Store(this.email, this.isLogged);

  @override
  List<Object?> get props => [email, isLogged];
}

