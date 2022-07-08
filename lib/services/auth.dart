import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isLogin() {
    String? token = prefs.getString("token");
    if (token != null) {
      return true;
    }
    return false;
  }

  void setAuth(String email, String token, int id) {
    prefs.setString("email", email);
    prefs.setString("token", token);
    prefs.setInt("id", id);
  }

  String? getToken() {
    return prefs.getString("token");
  }

  String? getEmail() {
    return prefs.getString("email");
  }
  int? getId() {
    return prefs.getInt("id");
  }

  void clear() {
    prefs.clear();
  }
}
