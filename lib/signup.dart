import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hourly_need/otp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String name, email, phone, pin, verificationId = '', errorMessage = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  bool canGo = false;

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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 0, right: 40, left: 40, bottom: 10,),
                          child: Text(
                            'Sign Up now',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 10, right: 40, left: 40, bottom: 40,),
                          child: Text(
                            'Enter required information',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name here',
                            labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            hintStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                          style: Theme.of(context).textTheme.headline5,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E - Mail',
                            hintText: 'Enter your email address here',
                            labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            hintStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          style: Theme.of(context).textTheme.headline5,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'Enter your phone number here',
                            labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            hintStyle: Theme.of(context).textTheme.headline5.copyWith(
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'PIN',
                            hintText: 'Enter a secured PIN number here',
                            labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            hintStyle: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (val) {
                            setState(() {
                              pin = val;
                            });
                          },
                          maxLength: 6,
                          maxLengthEnforced: true,
                          style: Theme.of(context).textTheme.headline5,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(name != null && email != null && phone != null && pin != null) {
                    if(pin.length == 6) {
                      prefs.setString('name', name);
                      prefs.setString('email', email);
                      prefs.setString('phone', phone);
                      prefs.setString('pin', pin);
                      verifyPhone();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Enter 6-digit Pin',
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: 'All fields must be filled',
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  margin: EdgeInsets.only(top: 10),
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register'.toUpperCase(),
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 26,
                        )
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

  Future<void> verifyPhone() async {
    setState(() {
      canGo = false;
      errorMessage = '';
    });
    Fluttertoast.showToast(
      msg: 'Please Wait',
    );
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (AuthCredential credential) {
        print(credential);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print(exception.code);
        setState(() {
          errorMessage = exception.message;
        });
        Fluttertoast.showToast(
          msg: exception.message,
        );
      },
      codeSent: (String verId, [int resendCode]) {
        Fluttertoast.showToast(
          msg: 'Requesting OTP',
        );
        setState(() {
          verificationId = verId;
          canGo = true;
        });
        print(verificationId);
        if(errorMessage == '' && verificationId != '' && canGo) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return OTP(verificationId, name, email, phone, pin);
              },
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (String verId) {
        setState(() {
          verificationId = verId;
        });
      },
    );
  }
}
