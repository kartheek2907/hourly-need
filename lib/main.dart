import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'splashscreen.dart';
import 'signup.dart';
import 'null.dart';
import 'home.dart';
import 'profile.dart';
import 'track.dart';
import 'settings.dart';
import 'complaintForm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future createJsonFile() async{
  final extDir = await getExternalStorageDirectory();
  String path = '${extDir.path}/details.json';
  File file = File(path);
  bool existing = await file.exists();
  if(!existing) {
    await file.writeAsString('{"app": "Hourly Need", "version": "V.0.1", "baseURL": "http://139.59.4.68/api/v1/"}', mode: FileMode.append);
  }
}

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.waitUntilFirstFrameRasterized;
  Firebase.initializeApp();
  createJsonFile();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashScreen(),
        'null' : (context) => Null(),
        'home' : (context) => Home(),
        'signup' : (context) => SignUp(),
        'profile' : (context) => Profile(),
        'track' : (context) => Track(),
        'settings' : (context) => Settings(),
        'complaintsForm' : (context) => Complaints(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(
            opacity: 1,
            size: 16,
            color: Colors.white,
          ),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            opacity: 1,
            size: 16,
            color: Colors.white,
          ),
          color: Color(0xFF20124D),
        ),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xFF4C1130),
        disabledColor: Color(0xFF4C1130),
        bottomAppBarColor: Color(0xFF20124D),
        dialogBackgroundColor: Color(0xFFF4F9F2),
        errorColor: Colors.redAccent,
        primaryColor: Color(0xFF20124D),
        hintColor: Color(0xFF4C1130),
        unselectedWidgetColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 36,
            fontFamily: 'ProductSans',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 30,
            fontFamily: 'ProductSans',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 24,
            fontFamily: 'ProductSans',
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontSize: 20,
            fontFamily: 'ProductSans',
            color: Colors.black,
          ),
          headline5: TextStyle(
            fontSize: 16,
            fontFamily: 'ProductSans',
            color: Colors.black,
          ),
          headline6: TextStyle(
            fontSize: 12,
            fontFamily: 'ProductSans',
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
