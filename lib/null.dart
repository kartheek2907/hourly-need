import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'loading.dart';

class Null extends StatefulWidget {
  @override
  _NullState createState() => _NullState();
}

class _NullState extends State<Null> {

  @override
  void initState() {
    isLoggedIn();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  isLoggedIn() async{
    final extDir = await getExternalStorageDirectory();
    String path = '${extDir.path}/details.json';
    File file = File(path);
    String data = await file.readAsString();
    Map<String, dynamic> mappedData = jsonDecode(data);
    if(mappedData['isLoggedIn'] != null && mappedData['isLoggedIn'] == true && mappedData['token'] != null) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      if(mappedData['isLoggedIn'] == null) {
        file.delete();
        data = data.replaceAll('}', ', ') + '"isLoggedIn": false}';
        file.writeAsString(data, mode: FileMode.append);
      }
      Navigator.pushReplacementNamed(context, 'signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShowLoading(),
      ),
    );
  }
}
