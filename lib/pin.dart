import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pin extends StatefulWidget {

  final String phone;

  Pin(this.phone);

  @override
  _PinState createState() => _PinState(phone);
}

class _PinState extends State<Pin> {

  final String phone;

  _PinState(this.phone);

  String pin, errorMsg = '';
  bool otpSuccess = false;
  String response = '';

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
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  if(pin.length == 6){
                    verifyPin(pin);
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Enter 6-digit pin'
                    );
                  }
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
            ),
          ],
        ),
      ),
    );
  }

  verifyPin(String pin) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool work = false;
    String url, mobile;
    setState(() {
      work = preferences.getBool('work');
    });
    setState(() {
      url = work ? 'http://139.59.4.68/api/v1/service/login' : 'http://139.59.4.68/api/v1/user/login';
      mobile = phone.replaceAll('+91', '');
    });
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'mobile': mobile,
        'password': pin,
      }),
    ).then((res) {
      print(res.statusCode);
      setState(() {
        response = res.body;
      });
      print(jsonDecode(response));
      if(jsonDecode(response)['token'] != null) {
        preferences.setBool('isLoggedIn', true);
        preferences.setString('token', jsonDecode(response)['token']);
        preferences.setString('name', jsonDecode(response)['name']);
        preferences.setString('email', jsonDecode(response)['email']);
        preferences.setString('phone', jsonDecode(response)['mobile']);
        preferences.setString('id', jsonDecode(response)['id'].toString());
        preferences.setString('hno', jsonDecode(response)['hno'].toString());
        preferences.setString('street', jsonDecode(response)['street']);
        preferences.setString('country', jsonDecode(response)['country']);
        preferences.setString('state', jsonDecode(response)['state']);
        preferences.setString('city', jsonDecode(response)['city']);
        preferences.setString('zip', jsonDecode(response)['zip'].toString());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Fluttertoast.showToast(
          msg: 'Error'
        );
      }
    });
  }
}