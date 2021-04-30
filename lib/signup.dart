import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'loading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/sms.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String name = '', phone = '', verificationId = '', errorMessage = '', otp = '', response = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  bool canGo = false;
  SmsReceiver _smsReceiver = SmsReceiver();
  Map<String, dynamic> mappedData;
  File file;

  @override
  void initState() {
    getDataFromJson();
    super.initState();
    _smsReceiver.onSmsReceived.listen((SmsMessage message) {
      if(message.body.contains('is your verification code') || message.body.contains('hourly-need')) {
        setState(() {
          otp = message.body.substring(0, 6);
        });
      }
    }).pause();
  }

  getDataFromJson() async{
    final extDir = await getExternalStorageDirectory();
    String path = '${extDir.path}/details.json';
    file = File(path);
    String data = await file.readAsString();
    mappedData = jsonDecode(data);
  }

  @override
  void dispose() {
    _smsReceiver.onSmsReceived.listen((SmsMessage message) {
      if(message.body.contains('is your verification code') || message.body.contains('hourly-need')) {
        setState(() {
          otp = message.body.substring(0, 6);
        });
      }
    }).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      color: Theme.of(context).dialogBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10,),
                            child: Text(
                              'Sign Up now',
                              style: Theme.of(context).textTheme.headline2.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 40,),
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
                          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                            style: Theme.of(context).textTheme.headline5,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              suffix: GestureDetector(
                                onTap: () {
                                  verifyPhone();
                                },
                                child: Text(
                                  'Send OTP',
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                phone = '+91' + val;
                              });
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                            style: Theme.of(context).textTheme.headline5,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'OTP',
                              hintText: 'Enter otp received on your phone number',
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
                            onFieldSubmitted: (val) {
                              setState(() {
                                otp = val;
                              });
                              FocusScope.of(context).nextFocus();
                            },
                            onChanged: (val) {
                              if(val.length == 6) {
                                setState(() {
                                  otp = val;
                                });
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            key: Key(otp),
                            initialValue: otp,
                            style: Theme.of(context).textTheme.headline5,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(phone != null) {
                            verifyPhone();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).dialogBackgroundColor,
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Resend OTP'.toUpperCase(),
                              style: Theme.of(context).textTheme.headline5.copyWith(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(name != null && phone != null && otp != null) {
                            mappedData.addAll({
                              "name": name,
                              "phone": phone,
                            });
                            verifyOTP(otp);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'All fields must be filled',
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Continue'.toUpperCase(),
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
      codeSent: (String verId, [int resendCode]) async{
        Fluttertoast.showToast(
          msg: 'Requesting OTP',
        );
        _smsReceiver.onSmsReceived.listen((SmsMessage message) {
          if(message.body.contains('is your verification code') || message.body.contains('hourly-need')) {
            setState(() {
              otp = message.body.substring(0, 6);
            });
          }
        }).onError((error) {
          Fluttertoast.showToast(
            msg: error.toString(),
          );
        });
        setState(() {
          verificationId = verId;
          canGo = true;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        setState(() {
          verificationId = verId;
        });
      },
    );
  }

  verifyOTP(String otp) async{
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    await auth.signInWithCredential(credential);
    User user = auth.currentUser;
    if(user.uid != null) {
      showLoading();
      mappedData.update('uid', (value) => user.uid, ifAbsent: () => user.uid);
      signUpInServer();
    } else {
      Fluttertoast.showToast(
        msg: 'Wrong OTP',
      );
      Navigator.pop(context);
    }
  }

  signUpInServer() async{
    String bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    String url, mobile;
    setState(() {
      url = bUrl + 'user/register';
      mobile = phone.replaceAll('+91', '');
    });
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'name': name,
        'mobile': mobile,
      }),
    ).then((res) async{
      print(res.statusCode);
      print(res.body);
      setState(() {
        response = res.body;
      });
      if(jsonDecode(response)['token'] != null) {
        Fluttertoast.showToast(
          msg: 'Sign up Successful',
        );
        file.delete();
        mappedData.update('isLoggedIn', (value) => true, ifAbsent: () => true);
        mappedData.update('token', (value) => jsonDecode(response)['token'], ifAbsent: () => jsonDecode(response)['token']);
        file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
        Navigator.pop(context);
        if(Navigator.canPop(context)) {
          Navigator.pushReplacementNamed(context, 'home');
        } else {
          Navigator.pushNamed(context, 'home');
        }
      }
    }).catchError((onError) {
      print(onError);
      if(!(response.contains('Duplicate entry'))) {
        Fluttertoast.showToast(
          msg: onError.toString(),
        );
        Navigator.pop(context);
      }
      if(response.contains('Duplicate entry')) {
        loginInServer();
      }
    });
  }

  loginInServer() async{
    String bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    String url, mobile;
    setState(() {
      url = bUrl + 'user/login';
      mobile = phone.replaceAll('+91', '');
    });
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'mobile': mobile,
      }),
    ).then((res) async{
      print(res.statusCode);
      print(res.body);
      setState(() {
        response = res.body;
      });
      if(jsonDecode(response)['token'] != null) {
        Fluttertoast.showToast(
          msg: 'Login Successful',
        );
        file.delete();
        mappedData.update('token', (value) => jsonDecode(response)['token'], ifAbsent: () => jsonDecode(response)['token']);
        mappedData.update('isLoggedIn', (value) => true, ifAbsent: () => true);
        file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
        Navigator.pop(context);
        if(Navigator.canPop(context)) {
          Navigator.pushReplacementNamed(context, 'home');
        } else {
          Navigator.pushNamed(context, 'home');
        }
      }
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: response,
      );
      Navigator.pop(context);
    });
  }

  showLoading() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ShowLoading(),
          contentPadding: EdgeInsets.all(10),
          scrollable: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
      },
      barrierDismissible: false,
    );
  }
}