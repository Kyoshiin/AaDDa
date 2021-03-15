import 'package:aadda/Model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManagement{
  static const IS_LOGIN = "IS_LOGIN";
  static const USER_NAME_KEY = "USER_NAME";
  static const USER_ID_KEY = "USER_ID";
  static const USER_EMAIL_KEY = "USER_EMAIL";
  static const USER_ABOUT_KEY = "USER_ABOUT";
  static const USER_PIC_KEY = "USER_PIC";

  static SharedPreferences sharedPreferences;

  static getCurrentUserID() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(USER_ID_KEY) ??
        ''; // if userID not present return null
  }

  static createLoginSession({UserModel user}) async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(IS_LOGIN, true);
    sharedPreferences.setString(USER_NAME_KEY, user.userName);
    sharedPreferences.setString(USER_ID_KEY, user.userID);
    sharedPreferences.setString(USER_EMAIL_KEY, user.userEmail);
    sharedPreferences.setString(USER_ABOUT_KEY, user.userAbout);
    sharedPreferences.setString(USER_PIC_KEY, user.userPic);
  }

  static logout() async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(IS_LOGIN, false);
    sharedPreferences.setString(USER_NAME_KEY, "");
    sharedPreferences.setString(USER_ID_KEY, "");
    sharedPreferences.setString(USER_EMAIL_KEY, "");
  }

  static getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> userDetails = {
      USER_EMAIL_KEY: sharedPreferences.getString(USER_EMAIL_KEY) ?? '',
      USER_NAME_KEY: sharedPreferences.getString(USER_NAME_KEY) ?? '',
      USER_ID_KEY: sharedPreferences.getString(USER_ID_KEY) ?? '',
      USER_ABOUT_KEY: sharedPreferences.getString(USER_ABOUT_KEY) ?? '',
      USER_PIC_KEY: sharedPreferences.getString(USER_PIC_KEY) ?? '',
    };

    return userDetails;
  }

  static Future<bool> IsLoggedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(IS_LOGIN) ?? false;
  }

  ///update user details after profile upgrade
  static updateUserDetails({UserModel user}) async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(USER_NAME_KEY, user.userName);
    sharedPreferences.setString(USER_ABOUT_KEY, user.userAbout);
    sharedPreferences.setString(USER_PIC_KEY, user.userPic);
  }
}
