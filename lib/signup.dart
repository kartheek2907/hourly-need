import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        'Sign Up now',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 40,),
                      child: Text(
                        'Enter required information',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ),
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
                  style: Theme.of(context).textTheme.headline4,
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
                  style: Theme.of(context).textTheme.headline4,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number here (with country code)',
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
                  style: Theme.of(context).textTheme.headline4,
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
                  style: Theme.of(context).textTheme.headline4,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/otp');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
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
        ],
      ),
    );
  }
}