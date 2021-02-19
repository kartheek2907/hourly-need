import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OTP extends StatefulWidget {

  final String verId;
  final String name;
  final String email;
  final String pin;
  final String phone;
  OTP(this.verId, this.name, this.email, this.phone, this.pin);

  @override
  _OTPState createState() => _OTPState(verId, name, email, phone, pin);
}

class _OTPState extends State<OTP> {

  final String verId;
  final String name;
  final String email;
  final String pin;
  final String phone;
  _OTPState(this.verId, this.name, this.email, this.phone, this.pin);

  String otp, errorMsg = '';
  bool otpSuccess = false;
  String response = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  SmsAutoFill smsAutoFill = SmsAutoFill();

  @override
  void initState() {
    super.initState();
  }

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
            Column(
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
                          'Enter verification code',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 40,),
                        child: Text(
                          'Enter code we\'ve sent on your phone number',
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
                      labelText: 'Enter 6 - digit verification code',
                      labelStyle: Theme.of(context).textTheme.headline4.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        otp = val;
                      });
                    },
                    maxLength: 6,
                    maxLengthEnforced: true,
                    style: Theme.of(context).textTheme.headline3.copyWith(
                      letterSpacing: 10,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        resendOTP();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width/2,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: Text(
                            'Not Received'.toUpperCase(),
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
                        verifyOTP(otp);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width/2,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        color: Theme.of(context).colorScheme.primary,
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
    );
  }

  resendOTP() {
    
  }

   verifyOTP(String otp) async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     AuthCredential credential = PhoneAuthProvider.credential(
       verificationId: verId,
       smsCode: otp,
     );
     await auth.signInWithCredential(credential).catchError((error) {
       Fluttertoast.showToast(
         msg: error.toString(),
       );
     });
     User user = auth.currentUser;
     if(user.uid != null) {
       preferences.setBool('isLoggedIn', true);
       signUpInServer();
     } else {
       Fluttertoast.showToast(
         msg: 'Wrong OTP',
       );
     }
   }

   signUpInServer() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     String url, mobile;
     bool work = false;
     setState(() {
       work = preferences.getBool('work');
     });
     setState(() {
       url = work ? 'http://139.59.4.68/api/v1/service/register' : 'http://139.59.4.68/api/v1/user/register';
       mobile = phone.replaceAll('+91', '');
     });
     await http.post(
       url,
       headers: <String, String>{
         'Content-Type': 'application/json',
       },
       body: jsonEncode(<String, dynamic> {
         'name': name,
         'email': email,
         'mobile': mobile,
         'password': pin,
       }),
     ).then((res) async{
       print(res.statusCode);
       setState(() {
         response = res.body;
       });
       if(jsonDecode(response)['success']) {
         await http.post(
           url,
           headers: <String, String>{
             'Content-Type': 'application/json',

           },
           body: jsonEncode(<String, dynamic> {
             'mobile': mobile,
             'password': pin,
           }),
         ).then((result) {
           preferences.setBool('isLoggedIn', true);
           preferences.setString('token', jsonDecode(result.body)['token']);
           preferences.setString('id', jsonDecode(result.body)['id'].toString());
           preferences.setString('hno', jsonDecode(result.body)['hno'].toString());
           preferences.setString('street', jsonDecode(result.body)['street']);
           preferences.setString('country', jsonDecode(result.body)['country']);
           preferences.setString('state', jsonDecode(result.body)['state']);
           preferences.setString('city', jsonDecode(result.body)['city']);
           preferences.setString('zip', jsonDecode(result.body)['zip'].toString());
         });
         preferences.setString('name', jsonDecode(response)['name']);
         preferences.setString('email', jsonDecode(response)['email']);
         preferences.setString('phone', jsonDecode(response)['mobile']);
         Navigator.pop(context);
         Navigator.pop(context);
         Navigator.pop(context);
         Navigator.pushReplacementNamed(context, '/home');
       } else {
         Fluttertoast.showToast(
             msg: 'Error in server'
         );
       }
     });
   }
}