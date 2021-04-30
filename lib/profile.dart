import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:path_provider/path_provider.dart';
import 'loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String name = '', phone = '', id = '', token = '', hNo = '', street = '', city = '', state = '', country = '', zip = '', resp = '', bUrl = '', imageUrl, curAdd = 'Loading...', location = '';
  double lat = 0.0, lng = 0.0;
  Position curLoc = Position();
  Map<String, dynamic> mappedData;
  File file;

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  getDetails() async{
    final extDir = await getExternalStorageDirectory();
    String path = '${extDir.path}/details.json';
    file = File(path);
    String data = await file.readAsString();
    mappedData = jsonDecode(data);
    setState(() {
      bUrl = mappedData['baseURL'];
      name = mappedData['name'];
      phone = mappedData['phone'];
      id = mappedData['id'];
      token = mappedData['token'];
      lat = mappedData['lat'];
      lng = mappedData['lng'];
    });
    String url;
    url = bUrl + 'user/searchUser?id=$id';
    showLoading();
    await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    ).then((result) {
      imageUrl = jsonDecode(result.body)[0]['avatar'];
      file.delete();
      mappedData.update('hno', (value) => jsonDecode(result.body)[0]['hno'].toString(), ifAbsent: () => jsonDecode(result.body)[0]['hno'].toString());
      if(jsonDecode(result.body)[0]['street'] != null && jsonDecode(result.body)[0]['country'] != null && jsonDecode(result.body)[0]['state'] != null && jsonDecode(result.body)[0]['city'] != null && jsonDecode(result.body)[0]['zip'] != null) {
        mappedData.update('street', (value) => jsonDecode(result.body)[0]['street'], ifAbsent: () => jsonDecode(result.body)[0]['street']);
        mappedData.update('city', (value) => jsonDecode(result.body)[0]['city'], ifAbsent: () => jsonDecode(result.body)[0]['city']);
        mappedData.update('state', (value) => jsonDecode(result.body)[0]['state'], ifAbsent: () => jsonDecode(result.body)[0]['state']);
        mappedData.update('country', (value) => jsonDecode(result.body)[0]['country'], ifAbsent: () => jsonDecode(result.body)[0]['country']);
        mappedData.update('zip', (value) => jsonDecode(result.body)[0]['zip'].toString(), ifAbsent: () => jsonDecode(result.body)[0]['zip'].toString());
      }
      setState(() {
        hNo = mappedData['hno'] != null ? mappedData['hno'] : '';
        street = mappedData['street'];
        city = mappedData['city'];
        state = mappedData['state'];
        country = mappedData['country'];
        zip = mappedData['zip'];
      });
      mappedData.update('address', (value) => street + ', ' + city + ', ' + state + ', ' + country + ' - ' + zip, ifAbsent: () => hNo + ', ' + street + ', ' + city + ', ' + state + ', ' + country + ' - ' + zip);
      file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'My Profile'.toUpperCase(),
            style: Theme.of(context).textTheme.headline5.copyWith(
              color: Colors.white,
            ),
          ),
          centerTitle: false,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            image: DecorationImage(
                              image: (imageUrl != null && !imageUrl.contains('Request Entity')) ? NetworkImage(
                                bUrl + 'image/getImage?image=' + imageUrl
                              ) : NetworkImage(
                                'https://www.shareicon.net/data/512x512/2016/02/22/722964_button_512x512.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  updateImage();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width - 180
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Change picture',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showUpdateLocation();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width - 180
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.edit_location_outlined,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Get Current Location',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
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
                        key: Key(name),
                        style: Theme.of(context).textTheme.headline5,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        readOnly: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        key: Key(phone),
                        style: Theme.of(context).textTheme.headline5,
                        keyboardType: TextInputType.phone,
                        readOnly: true,
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    //   width: MediaQuery.of(context).size.width,
                    //   child: TextFormField(
                    //     key: Key(hNo),
                    //     decoration: InputDecoration(
                    //       labelText: 'H - No',
                    //       labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                    //         color: Theme.of(context).colorScheme.secondary,
                    //       ),
                    //       enabledBorder: OutlineInputBorder(),
                    //       border: OutlineInputBorder(),
                    //       isDense: true,
                    //     ),
                    //     initialValue: hNo,
                    //     style: Theme.of(context).textTheme.headline5,
                    //     keyboardType: TextInputType.text,
                    //     onChanged: (val) {
                    //       setState(() {
                    //         newHno = val;
                    //         isChanged = true;
                    //       });
                    //     },
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        readOnly: true,
                        initialValue: street,
                        style: Theme.of(context).textTheme.headline5,
                        onTap: () {
                          showUpdateLocation();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        readOnly: true,
                        initialValue: city,
                        style: Theme.of(context).textTheme.headline5,
                        onTap: () {
                          showUpdateLocation();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        readOnly: true,
                        initialValue: state,
                        style: Theme.of(context).textTheme.headline5,
                        onTap: () {
                          showUpdateLocation();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        readOnly: true,
                        initialValue: country,
                        style: Theme.of(context).textTheme.headline5,
                        onTap: () {
                          showUpdateLocation();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        readOnly: true,
                        initialValue: zip,
                        style: Theme.of(context).textTheme.headline5,
                        onTap: () {
                          showUpdateLocation();
                        },
                      ),
                    ),
                    Container(
                      height: 80,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    update();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Theme.of(context).accentColor,
                    child: Center(
                      child: Text(
                        'Update details'.toUpperCase(),
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
      ),
    );
  }

  showUpdateLocation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Text(
            'Update to current location?',
            style: Theme.of(context).textTheme.headline5,
          ),
          actionsPadding: EdgeInsets.only(right: 10, bottom: 10),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _getCurrentLocation();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Text(
                  'Ok',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  update() async{
    String url, bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    url = bUrl + 'user/updateUser';
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'avatar': imageUrl,
        'id': id,
        'hno': hNo != null ? hNo : '',
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'zip': zip,
        'lat': lat,
        'lng': lng,
      }),
    ).then((res) {
      Fluttertoast.showToast(
        msg: jsonDecode(res.body)['message'],
      );
      getDetails();
    });
  }

  updateImage() async{
    var image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    File file = File(image.path);
    String url, bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    url = bUrl + 'user/uploadUserImage';
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    Map<String,String> headers={
      "Authorization":"Bearer $token",
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path,
      ),
    );
    request.headers.addAll(headers);
    var res = await request.send();
    res.stream.forEach((element) {
      resp = '';
      element.forEach((element) {
        resp = resp + String.fromCharCode(element);
      });
      setState(() {
        imageUrl = resp.substring(9, resp.length - 2);
      });
      print(imageUrl);
    }).whenComplete(() {
      if(imageUrl.contains('Too Large')) {
        Fluttertoast.showToast(
          msg: 'File is too large select smaller file.',
        );
      } else {
        update();
      }
    });
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        curLoc = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    Navigator.pop(context);
    final coordinates = new Coordinates(curLoc.latitude, curLoc.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      street = address.first.featureName + ', ' + address.first.subLocality;
      city = address.first.locality;
      state = address.first.adminArea;
      country = address.first.countryName;
      zip = address.first.postalCode;
      curAdd = address.first.addressLine;
      location = address.first.addressLine;
      lat = curLoc.latitude;
      lng = curLoc.longitude;
    });
    file.delete();
    mappedData.update('location', (value) => curAdd, ifAbsent: () => curAdd);
    mappedData.update('street', (value) => address.first.featureName + ', ' + address.first.subLocality, ifAbsent: () => address.first.featureName + ', ' + address.first.subLocality);
    mappedData.update('city', (value) => address.first.locality, ifAbsent: () => address.first.locality);
    mappedData.update('state', (value) => address.first.adminArea, ifAbsent: () => address.first.adminArea);
    mappedData.update('country', (value) => address.first.countryName, ifAbsent: () => address.first.countryName);
    mappedData.update('zip', (value) => address.first.postalCode, ifAbsent: () => address.first.postalCode);
    mappedData.update('lat', (value) => coordinates.latitude, ifAbsent: () => coordinates.latitude);
    mappedData.update('lng', (value) => coordinates.longitude, ifAbsent: () => coordinates.longitude);
    file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
  }

  showLoading() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ShowLoading(),
          contentPadding: EdgeInsets.all(10),
          scrollable: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
      },
      barrierDismissible: false,
    );
  }
}