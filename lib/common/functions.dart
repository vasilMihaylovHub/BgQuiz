
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static const String _userLoggedInKey = "USERLOGGEDINKEY";

  static saveCurrentUser({required bool isLoggedIn}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_userLoggedInKey, isLoggedIn);
  }

  static Future<bool?> getCurrentUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userLoggedInKey);
  }
}