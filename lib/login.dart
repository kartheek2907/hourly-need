import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hourly_need/pin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String phone, errorMessage = '', verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0, right: 40, left: 40, bottom: 10,),
                          child: Text(
                            'Enter your registered phone number',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 40,),
                          child: Text(
                            'Sign in with your phone number',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Phone Number',
                        labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        enabledBorder: OutlineInputBorder(),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (val) {
                        setState(() {
                          phone = '+91' + val;
                        });
                      },
                      style: Theme.of(context).textTheme.headline5,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width/2,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: Text(
                            'New User?'.toUpperCase(),
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Pin(phone);
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width/2,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: Text(
                            'Sign In'.toUpperCase(),
                            style: Theme.of(context).textTheme.headline5.copyWith(
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
            ),
          ],
        ),
      ),
    );
  }
}