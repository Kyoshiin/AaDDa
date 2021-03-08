import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SessionManagement{
  static const APP_PREF = "Aadda";
  static const IS_LOGIN = "IS_LOGIN";
  static const USER_NAME = "USER_NAME";
  static const USER_ID  = "USER_ID";
  static const USER_EMAIL = "USER_EMAIL";

  static SharedPreferences sharedPreferences;


  static createLoginSession({String name,String uid, String email}) async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(IS_LOGIN, true);
    sharedPreferences.setString(USER_NAME, name);
    sharedPreferences.setString(USER_ID, uid);
    sharedPreferences.setString(USER_EMAIL, email);

  }

  static logout() async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(IS_LOGIN, false);
    sharedPreferences.setString(USER_NAME, "");
    sharedPreferences.setString(USER_ID, "");
    sharedPreferences.setString(USER_EMAIL, "");

  }

  static Future<bool> IsLoggedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool(IS_LOGIN)??false;
  }
}
