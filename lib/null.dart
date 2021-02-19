import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Null extends StatefulWidget {
  @override
  _NullState createState() => _NullState();
}

class _NullState extends State<Null> {

  @override
  void initState() {
    isLoggedIn();
    super.initState();
  }

  isLoggedIn() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.get('isLoggedIn') != null && preferences.get('isLoggedIn') == true) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      preferences.setBool('isLoggedIn', false);
      Navigator.pushReplacementNamed(context, '/workorhire');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
