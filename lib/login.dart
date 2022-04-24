import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventory/barang/listBarang.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/helper/input.dart';
import 'package:inventory/model/auth.dart';
import 'package:inventory/repository/auth_repository.dart';
import 'package:page_transition/page_transition.dart';

class LoginPIN extends StatefulWidget {
  @override
  _LoginPINState createState() => _LoginPINState();
}

class _LoginPINState extends State<LoginPIN> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  // ..text = "123456";
  Connection conn = new Connection();
  var obsuced = true;

  void login() async {
    setState(() {
      Config.loading(context);
    });
    conn.initDB();
    AuthRepository authRepository = new AuthRepository();
    Auth _auth = new Auth();
    _auth.username = txtUsername.text;
    _auth.pin = txtPassword.text;

    bool respon = await authRepository.login(_auth);
    if (respon == true) {
      setState(() {
        Navigator.pop(context);
        Config.alert(1, 'Login Berhasil');
        Navigator.of(context).pushReplacement(PageTransition(child: ListBarang(), type: PageTransitionType.fade));
      });
    } else {
      setState(() {
        Navigator.pop(context);
        Config.alert(2, 'Login gagal');
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // snackBar Widget
  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: Container(
          color: Config.textWhite,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'LOGIN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: Text('Username'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: formInputType(txtUsername, 'Username', TextInputType.text),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                child: Text('Password'),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Config.borderInput)),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                          style: TextStyle(color: Colors.black54),
                          obscureText: obsuced,
                          keyboardType: TextInputType.text,
                          controller: txtPassword,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            fillColor: Colors.black54,
                            suffixIcon: IconButton(
                              color: Colors.blue,
                              icon: obsuced ? Icon(Icons.lock_outline_rounded) : Icon(Icons.lock_open),
                              onPressed: () {
                                if (obsuced == true) {
                                  setState(() {
                                    obsuced = false;
                                  });
                                } else {
                                  setState(() {
                                    obsuced = true;
                                  });
                                }
                              },
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                // color: Config.textWhite,
                                fontSize: 16),
                            border: InputBorder.none,
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  buttonColor: Colors.blue,
                  child: TextButton(
                    onPressed: () {
                      // if (txtUsername.text.isEmpty || txtPassword.text.isEmpty) {
                      //   Config.alert(0, 'Lengkapi username dan password');
                      // } else {
                      login();
                      // }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
