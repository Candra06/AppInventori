import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    return token;
  }

  static getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString('name');
    return name;
  }

  static getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString('username');
    return username;
  }
  static getID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    return id;
  }

  static getPath() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String direktori = preferences.getString('direktori');
    return direktori;
  }
}
