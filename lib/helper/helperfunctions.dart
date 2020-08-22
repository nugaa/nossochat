import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferencesLoggedKey = "ISLOGGED";
  static String sharedPreferencesUserNameKey = "USERNAMEKEY";
  static String sharedPreferencesEmailKey = "USEREMAILKEY";

  // SALVAR DADOS PARA SHAREDPREFERENCES

  static Future<bool> salvarUserLogged(bool isUserLogged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setBool(sharedPreferencesLoggedKey, isUserLogged);
  }

  static Future<bool> salvarUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setString(sharedPreferencesUserNameKey, username);
  }

  static Future<bool> salvarUserEmail(String useremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setString(sharedPreferencesUserNameKey, useremail);
  }

  // OBTER DADOS DE SHAREDPREFERENCES

  static Future<bool> getUserLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.getBool(sharedPreferencesLoggedKey);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.getString(sharedPreferencesUserNameKey);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.getString(sharedPreferencesUserNameKey);
  }


}
