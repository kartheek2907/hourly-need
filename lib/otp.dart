import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {

  String otp;
  bool otpSuccess = false;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
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
              ],
            ),
            Container(
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
          ],
        ),
      ),
    );
  }

  resendOTP() {

  }

   verifyOTP(String otp) {
     if(!otpSuccess) {
       Navigator.pop(context);
       Navigator.pop(context);
       Navigator.pop(context);
       Navigator.pushReplacementNamed(context, '/home');
     }
   }
}