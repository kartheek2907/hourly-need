import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {

  Position curLoc;
  String curAdd = '';

  @override
  void initState() {
    _getCurrentLocation();
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.only(top: 0, bottom: 20, left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Address',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'List of your addresses',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      'Current Location:',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Text(
                      curAdd,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                          Icons.add_location,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Save this location',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      'Home:',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Text(
                      curAdd,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      'Work:',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Text(
                      curAdd,
                      style: Theme.of(context).textTheme.headline5,
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

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        curLoc = position;
      });
      print(curLoc);
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final coordinates = new Coordinates(curLoc.latitude, curLoc.longitude);
    print('getting add');
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      curAdd = addresses.first.addressLine;
    });
    prefs.setString('location', curAdd);
    print(curAdd);
  }
}