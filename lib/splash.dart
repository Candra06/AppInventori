import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventory/barang/listBarang.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/helper/pref.dart';
import 'package:inventory/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  String token = '';

  permissionServiceCall() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      // Permission.camera,
      // Permission.microphone,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage].isPermanentlyDenied) {
      openAppSettings();
      setState(() {});
    } else {
      if (statuses[Permission.storage].isDenied) {
        permissionServiceCall();
      }
    }

    return statuses;
  }

  _createFolder() async {
    final folderName = "inventory";
    final directory = await getExternalStorageDirectory();
    final fold = await getApplicationDocumentsDirectory();
    String folder = directory.path.toString().replaceAll('files', 'databases');
    print("path baru " + folder);
    print("path baru " + fold.path);
    final path = Directory("storage/emulated/0/$folderName/database");
    final pathImage = Directory("storage/emulated/0/$folderName/foto");
    // final path = Directory(folder);
    print(path);
    SharedPreferences pref = await SharedPreferences.getInstance();
    if ((await path.exists())) {
      print("exist");
      pref.setString("direktori", "storage/emulated/0/$folderName/foto");
      pref.setString("db", "storage/emulated/0/$folderName/database");
    } else {
      print("not exist");
      path.create();
      pathImage.create();
      pref.setString("direktori", "storage/emulated/0/$folderName/foto");
      pref.setString("db", "storage/emulated/0/$folderName/database");
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
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    Future.delayed(Duration(seconds: 3), () async {
      String token = await Pref.getToken();
      if (token == null || token == 'null') {
        Navigator.of(context).pushReplacement(PageTransition(child: LoginPIN(), type: PageTransitionType.fade));
      } else {
        Navigator.of(context).pushReplacement(PageTransition(child: ListBarang(), type: PageTransitionType.fade));
      }

      //   // }
    });
    // getData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'asset/images/logo.png',
                            height: 190.0,
                            width: 190.0,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Waserda Jaya Cor', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 50))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
