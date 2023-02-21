// ignore_for_file: unused_field, file_names, prefer_typing_uninitialized_variables

import 'package:shared_preferences/shared_preferences.dart';

class UserSharePreferences {
  static var prefs;
  static const email = "Email";
  static const name = "UserName";
  static const isLogined = "isLogin";
  static const eId = "EmployeeId";
  static const bId = "BusinessId";
  static const pass = "Password";
  static Future logoutEmployee() async {
    // await UserSharePreferences.setBusinessId(0);
    // await UserSharePreferences.setEmployeeId("0000");
    await UserSharePreferences.setLoginStts(false);
    // await UserSharePreferences.setName("N/A");
    // await UserSharePreferences.setName("N/A");
  }

  static Future init() async => prefs = await SharedPreferences.getInstance();
  static Future setEmployeeId(String id) async =>
      await prefs.setString(eId, id);
  static String getEmployeeId() => prefs.getString(eId) ?? "0002";
  static Future setBusinessId(int id) async => await prefs.setInt(bId, id);
  static int getBusinessId() => prefs.getInt(bId) ?? 1;
  static Future setName(String tName) async =>
      await prefs.setString(name, tName);
  static String getName() => prefs.getString(name) ?? "Ahsan";
  static Future setPassword(String password) async =>
      await prefs.setString(pass, password);
  static String getPassword() => prefs.getString(pass) ?? "allah";
  static Future setEmail(String mail) async =>
      await prefs.setString(email, mail);
  static String getEmail() =>
      prefs.getString(email) ?? "ahsanakram99@gmail.com";
  static Future setLoginStts(bool islogin) async =>
      await prefs.setBool(isLogined, islogin);
  static bool getLoginStts() => prefs.getBool(isLogined) ?? false;
}
