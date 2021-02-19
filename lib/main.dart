import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'workOrHire.dart';
import 'splashscreen.dart';
import 'login.dart';
import 'signup.dart';
import 'null.dart';
import 'home.dart';
import 'orders.dart';
import 'profile.dart';
import 'todaysOrders.dart';
import 'address.dart';
import 'invoice.dart';
import 'track.dart';
import 'settings.dart';
import 'complaintForm.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.waitUntilFirstFrameRasterized;
  Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashScreen(),
        '/null' : (context) => Null(),
        '/login' : (context) => Login(),
        '/workorhire' : (context) => WorkOrHire(),
        '/home' : (context) => Home(),
        '/signup' : (context) => SignUp(),
        '/orders' : (context) => Orders(),
        '/todaysorders' : (context) => TodaysOrders(),
        '/profile' : (context) => Profile(),
        '/address' : (context) => Address(),
        '/invoice' : (context) => Invoice(),
        '/track' : (context) => Track(),
        '/settings' : (context) => Settings(),
        '/complaintsForm' : (context) => Complaints(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Color(0xFF5BD419),
          primaryVariant: Color(0xFF5BD419),
          secondary: Color(0xFF686868),
          secondaryVariant: Color(0xFF686868),
          surface: Color(0xFFF4F9F2),
          background: Colors.white,
          error: Colors.red,
          onPrimary: Color(0xFF000000),
          onSecondary: Color(0xFF686868),
          onSurface: Color(0xFF000000),
          onBackground: Colors.white,
          onError: Colors.red,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 48,
            fontFamily: 'ProductSans',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 40,
            fontFamily: 'ProductSans',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 30,
            fontFamily: 'ProductSans',
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontSize: 24,
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