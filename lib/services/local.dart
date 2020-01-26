// 本地存储
import 'package:shared_preferences/shared_preferences.dart';

class Local {
  static getString(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static setString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }
}
