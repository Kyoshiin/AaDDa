import 'package:shared_preferences/shared_preferences.dart';
class SessionManagement{
  static const APP_PREF = "Aadda";
  static const IS_LOGIN = "IS_LOGIN";
  static const USER_NAME_KEY = "USER_NAME";
  static const USER_ID_KEY = "USER_ID";
  static const USER_EMAIL_KEY = "USER_EMAIL";

  static SharedPreferences sharedPreferences;

  static getCurrentUserID() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString(USER_ID_KEY);
  }

  static createLoginSession({String name, String uid, String email}) async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(IS_LOGIN, true);
    sharedPreferences.setString(USER_NAME_KEY, name);
    sharedPreferences.setString(USER_ID_KEY, uid);
    sharedPreferences.setString(USER_EMAIL_KEY, email);
  }

  static logout() async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(IS_LOGIN, false);
    sharedPreferences.setString(USER_NAME_KEY, "");
    sharedPreferences.setString(USER_ID_KEY, "");
    sharedPreferences.setString(USER_EMAIL_KEY, "");
  }

  static Future<bool> IsLoggedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(IS_LOGIN)??false;
  }
}
