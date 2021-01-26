import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  int cInd = 0, sInd = 0;
  bool active = true;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 0, right: 40, left: 40, bottom: 0,),
                        child: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 20,),
                        child: Text(
                          'Your service details',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Switch(
                          value: active,
                          onChanged: (val) {
                            setState(() {
                              active = val;
                            });
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          active ? 'Servicing' : 'Out of service',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
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
                  labelText: 'Service Type',
                  labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                initialValue: 'Water works',
                style: Theme.of(context).textTheme.headline5,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Service Charge',
                  labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefix: Text(
                    '₹',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                initialValue: '500.00',
                style: Theme.of(context).textTheme.headline5,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Category',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width/2 - 20,
                      ),
                      padding: EdgeInsets.only(left: 20,),
                      child: DropdownButtonFormField(
                        value: cInd,
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              'Opt 1',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            value: 0,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Opt 2',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            value: 1,
                          ),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        isDense: true,
                        onChanged: (val) {
                          setState(() {
                            cInd = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 10),
                      child: Text(
                        'Sub-category',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width/2 - 20,
                      ),
                      padding: EdgeInsets.only(right: 20),
                      child: DropdownButtonFormField(
                        value: sInd,
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              'Opt 1',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            value: 0,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Opt 2',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            value: 1,
                          ),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        isDense: true,
                        onChanged: (val) {
                          setState(() {
                            cInd = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Service License NO',
                  labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                readOnly: true,
                initialValue: 'JHbbty62456'.toUpperCase(),
                style: Theme.of(context).textTheme.headline5,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Service Description',
                  labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                initialValue: 'Services all types of water works.',
                expands: false,
                minLines: 1,
                maxLines: 5,
                style: Theme.of(context).textTheme.headline5,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Services:',
                style: Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Taps',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Pipes',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Valves',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      '+add more',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    'Glass Charges',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: MediaQuery.of(context).size.width/4,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefix: Text(
                        '₹',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    initialValue: '200.00',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    'Oil Charges',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: MediaQuery.of(context).size.width/4,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefix: Text(
                        '₹',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    initialValue: '50.00',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    'Gas Charges',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: MediaQuery.of(context).size.width/4,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefix: Text(
                        '₹',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    initialValue: '100.00',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.words,
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
                      'Update'.toUpperCase(),
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 20,
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
      ),
    );
  }
}
