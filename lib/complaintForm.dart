import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Complaints extends StatefulWidget {
  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
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
                        'My Profile',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 10,),
                      child: Text(
                        'Your account details',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Complaint Description',
                    labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.article_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  initialValue: 'Complaint........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................',
                  expands: false,
                  minLines: 1,
                  maxLines: 5,
                  style: Theme.of(context).textTheme.headline5,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20),
            margin: EdgeInsets.only(top: 10),
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Update details'.toUpperCase(),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.upload_rounded,
                    color: Colors.white,
                    size: 26,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
