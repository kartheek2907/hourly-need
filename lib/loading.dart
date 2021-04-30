import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ShowLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
