import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/helper/appConfig.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/helper/route.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((_) {
    runApp(AppConfig(appName: "Inventori App", flavorName: "dev", initialRoute: Routes.SPLASH, child: MyApp()));
  });
  // MyApp.initSystemDefault();
}

class MyApp extends StatelessWidget {
 
 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var initialRoute = AppConfig.of(context).initialRoute;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: initialRoute,
      title: 'Inventori',
    );
  }

  static void initSystemDefault() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }
}
