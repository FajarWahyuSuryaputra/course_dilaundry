import 'dart:convert';

import 'package:course_dilaundry/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSession {
  static Future<UserModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    String? userString = pref.getString('user');
    if (userString == null) return null;

    var userMap = jsonDecode(userString);
    return UserModel.fromJson(userMap);
  }

  static Future<bool> setUser(Map userMap) async {
    final pref = await SharedPreferences.getInstance();
    String userString = jsonEncode(userMap);
    bool success = await pref.setString('user', userString);
    return success;
  }

  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    return success;
  }

  static Future<String?> getBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    return token;
  }

  static Future<bool> setBearerToken(String bearerToken) async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.setString('token', bearerToken);
    return success;
  }

  static Future<bool> removeBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('token');
    return success;
  }
}
