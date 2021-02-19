import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkOrHire extends StatefulWidget {
  @override
  _WorkOrHireState createState() => _WorkOrHireState();
}

class _WorkOrHireState extends State<WorkOrHire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/3,
            child: Image.asset('assets/logo.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('work', true);
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Text(
                        'Work'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('work', false);
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text(
                        'Hire'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}