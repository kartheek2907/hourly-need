import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {

  String pin;
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
                          'Enter pin',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 40,),
                        child: Text(
                          'Enter pin you have set while registration',
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
                      labelText: 'Enter 6 - digit pin',
                      labelStyle: Theme.of(context).textTheme.headline4.copyWith(
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
                    style: Theme.of(context).textTheme.headline3.copyWith(
                      letterSpacing: 10,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                verifyPin(pin);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 25),
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Text(
                    'Verify Pin'.toUpperCase(),
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
    );
  }

  verifyPin(String otp) {
    if(!otpSuccess) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}