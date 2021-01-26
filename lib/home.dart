import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String searchText = '';
  int cInd = 0, sInd = 0;
  bool manual = true, auto = false, searching = false, work = false, active = false;

  @override
  void initState() {
    workOrHire();
    super.initState();
  }

  workOrHire() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      work = prefs.getBool('work');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width/1.7,
              ),
              child: Text(
                '2nd Ln, Vidyanagar, Guntur, Andhra Pradesh 522007',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: work ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width*0.85,
                    minWidth: MediaQuery.of(context).size.width*0.85,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Home care pvt ltd,\nDoor no - 1, Street no - 1, City',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Column(
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
                      active ? 'Active' : 'Inactive',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ],
            ),
            if(active) Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'New Orders',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width/2 - 10,
                          minWidth: MediaQuery.of(context).size.width/2 - 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/pp.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kathy More'.toUpperCase(),
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'DoorNo- 1,Street No-26, VA-300045',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  'Distance: 5km',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  'Mobile: 9876543210',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 10.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                ),
                                color: Colors.green,
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight: 50,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 10.5,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight: 50,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Quotation',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 10.5,
                              decoration: BoxDecoration(
                                color: Colors.brown.withOpacity(0.5),
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight: 50,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Invoice',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 10.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Colors.redAccent,
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight: 50,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Reject',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if(active) Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Today\'s Orders',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width/2 - 10,
                          minWidth: MediaQuery.of(context).size.width/2 - 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/pp.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kathy More'.toUpperCase(),
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'DoorNo- 1,Street No-26, VA-300045',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  'Distance: 5km',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  'Mobile: 9876543210',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 10.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                ),
                                color: Colors.green,
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight: 50,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Start',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 10.5,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight: 50,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Quotation',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 10.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Colors.brown.withOpacity(0.5),
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                maxHeight: 50,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Invoice',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Kathy More,\nDoor no - 1, Street no - 1, City',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: 'Search for service',
                  labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  contentPadding: EdgeInsets.all(5),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                cursorColor: Theme.of(context).colorScheme.primary,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline5,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Wrap(
                direction: Axis.horizontal,
                runSpacing: 10,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Electrical',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Plumbing',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Painting',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'House Hold',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Steel Works',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Wood works',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Glass Works',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'More',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select category',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/3,
                    ),
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
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select sub-category',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/3,
                    ),
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
                          sInd = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: 'Work description',
                  labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  hintText: 'Enter your requirement here',
                  hintStyle: Theme.of(context).textTheme.headline6,
                  contentPadding: EdgeInsets.all(5),
                  prefixIcon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                cursorColor: Theme.of(context).colorScheme.primary,
                expands: false,
                minLines: 1,
                maxLines: 4,
                style: Theme.of(context).textTheme.headline5,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Manual',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Checkbox(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: manual,
                        onChanged: (val) {
                          setState(() {
                            manual = val;
                            searching = false;
                          });
                          if(manual) {
                            setState(() {
                              auto = false;
                            });
                          }
                          if(!manual && !auto) {
                            setState(() {
                              manual = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Auto',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Checkbox(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: auto,
                        onChanged: (val) {
                          setState(() {
                            auto = val;
                            searching = false;
                          });
                          if(auto) {
                            setState(() {
                              manual = false;
                            });
                          }
                          if(!manual && !auto) {
                            setState(() {
                              auto = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searching = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'Search',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(manual && searching) Container(
              margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/company.png'),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Company Name'.toUpperCase(),
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rating: 4/5',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '3km',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '₹500.00',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2 - 10.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Colors.greenAccent,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Quotation',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        width: 1,
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2 - 10.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.green,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Hire',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if(manual && searching) Container(
              margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/company.png'),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Company Name'.toUpperCase(),
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rating: 4/5',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '3km',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '₹500.00',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2 - 10.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Colors.greenAccent,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Quotation',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        width: 1,
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2 - 10.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.green,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Hire',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if(auto && searching) Container(
              margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/company.png'),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Company Name'.toUpperCase(),
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rating: 4/5',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '3km',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '₹500.00',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/3 - 22/3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Colors.greenAccent,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Quotation',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        width: 1,
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/3 - 22/3,
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Hire',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        width: 1,
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/3 - 22/3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.redAccent,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Reject',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: work ? Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/pp.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width/2,
                            maxWidth: MediaQuery.of(context).size.width/2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 30,
                                ),
                                child: Text(
                                  'Sam Smith',
                                  style: Theme.of(context).textTheme.headline4.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '+91 98765 43210',
                                style: Theme.of(context).textTheme.headline6.copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width/1.5,
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Home',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.account_box,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'My Profile',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'My Address',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/address');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.work,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'My Orders',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mail,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Complaint From',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/complaintsForm');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'FAQs',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mail,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Contact Us',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ) : Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/pp.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width/2,
                            maxWidth: MediaQuery.of(context).size.width/2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 30,
                                ),
                                child: Text(
                                  'Sam Smith',
                                  style: Theme.of(context).textTheme.headline4.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '+91 98765 43210',
                                style: Theme.of(context).textTheme.headline6.copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width/1.5,
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Home',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.account_box,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'My Profile',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'My Address',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/address');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.work_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Today\'s Orders',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/todaysorders');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.work,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'My Orders',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'FAQs',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mail,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Contact Us',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}