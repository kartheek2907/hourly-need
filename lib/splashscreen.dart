import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Image image;

  @override
  void initState() {
    image = Image.asset('assets/logo.png');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image.image, context).whenComplete(() {
      goNext();
    });
  }

  goNext() async{
    await Future.delayed(
      Duration(seconds: 3),
    );
    Navigator.pushReplacementNamed(context, '/null');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              child: image,
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