import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory/helper/network.dart';
import 'package:inventory/model/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<bool> login(Auth auth) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(auth.toJson());
    http.Response res = await http.post(Uri.parse(EndPoint.login), body: auth.toJson());
    print(Uri.parse(EndPoint.login));
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      preferences.setString('token', 'Bearer ' + data['access_token']);
      preferences.setString('id', data['data']['id'].toString());
      preferences.setString('name', data['data']['name']);
      preferences.setString('username', data['data']['username']);
      return true;
    } else {
      return false;
    }
  }
}
