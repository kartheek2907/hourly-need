import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String name, email, phone, id, token, hNo = '', street = '', city = '', state = '', country = '', zip = '', newHno, newStreet, newCity, newState, newCountry, newZip;
  bool work;

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  getDetails() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.get('name');
      email = preferences.get('email');
      phone = preferences.get('phone');
      id = preferences.get('id');
      work = preferences.get('work');
      token = preferences.get('token');
    });
    String url;
    url = work ? 'http://139.59.4.68/api/v1/service/updateUser' : 'http://139.59.4.68/api/v1/user/searchUser?id=$id';
    await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    ).then((result) {
      preferences.setString('hno', jsonDecode(result.body)[0]['hno'].toString());
      preferences.setString('street', jsonDecode(result.body)[0]['street']);
      preferences.setString('country', jsonDecode(result.body)[0]['country']);
      preferences.setString('state', jsonDecode(result.body)[0]['state']);
      preferences.setString('city', jsonDecode(result.body)[0]['city']);
      preferences.setString('zip', jsonDecode(result.body)[0]['zip'].toString());
      setState(() {
        hNo = preferences.get('hno') != null ? preferences.get('hno') : '';
        street = preferences.get('street') != null ? preferences.get('street') : '';
        city = preferences.get('city') != null ? preferences.get('city') : '';
        state = preferences.get('state') != null ? preferences.get('state') : '';
        country = preferences.get('country') != null ? preferences.get('country') : '';
        zip = preferences.get('zip') != null ? preferences.get('zip') : '';
      });
      preferences.setString('address', hNo + ', ' + street + ', ' + city + ', ' + state + ', ' + country + ' - ' + zip);
    });
    if(zip == '') {
      Fluttertoast.showToast(
        msg: 'Enter all details',
      );
    }
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
        child: Stack(
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
                        padding: EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 80,),
                        child: Text(
                          'Your account details',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                name != null ? Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      hintText: name,
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: name,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    readOnly: true,
                  ),
                ) : Container(),
                email != null ? Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E - Mail',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: email,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                  ),
                ) : Container(),
                phone != null ? Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: phone,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                  ),
                ) : Container(),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    key: Key(hNo),
                    decoration: InputDecoration(
                      labelText: 'H - No',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: hNo,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      setState(() {
                        newHno = val;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    key: Key(street),
                    decoration: InputDecoration(
                      labelText: 'Street',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: street,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (val) {
                      setState(() {
                        newStreet = val;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    key: Key(city),
                    decoration: InputDecoration(
                      labelText: 'City',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: city,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) {
                      setState(() {
                        newCity = val;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    key: Key(state),
                    decoration: InputDecoration(
                      labelText: 'State',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: state,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) {
                      setState(() {
                        newState = val;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    key: Key(country),
                    decoration: InputDecoration(
                      labelText: 'Country',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: country,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) {
                      setState(() {
                        newCountry = val;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    key: Key(zip),
                    decoration: InputDecoration(
                      labelText: 'ZIP Code',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: zip,
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        newZip = val;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    update();
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
                ),
              ],
            ),
            Positioned(
              top: 110,
              left: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      image: DecorationImage(
                        image: AssetImage('assets/pp.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Icon(
                      Icons.add_a_photo,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Change picture',
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

  update() async{
    String url;
    url = work ? 'http://139.59.4.68/api/v1/service/updateUser' : 'http://139.59.4.68/api/v1/user/updateUser';
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'id': id,
        'hno': newHno,
        'street': newStreet,
        'city': newCity,
        'state': newState,
        'country': newCountry,
        'zip': newZip,
      }),
    ).then((res) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/profile');
    });
  }
}