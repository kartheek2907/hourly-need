import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    isLoggedIn();
    super.initState();
  }

  isLoggedIn() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.get('isLoggedIn') != null && preferences.get('isLoggedIn') == true) {
      sleep(Duration(seconds: 3),);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      sleep(Duration(seconds: 3),);
      Navigator.pushReplacementNamed(context, '/workorhire');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width/2,
              child: Image.asset('assets/HN Logo.png'),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              'Hourly Need',
              style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/3,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'V.0.1',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
