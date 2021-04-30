import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'loading.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  int newSelectedCat, newSelectedSubCat, count = 0, num = 0;
  double lat, lng;
  String aadharNumber = '', licenseNumber = '', newLicenseNumber = '', newServiceName = '', newMinCharge = '', newAadharNumber = '', newServiceDescription = '', id, token, rating = 'Not rated yet';
  bool active = false, isChanged = false, updateOnlyAadhar = false, working = false;
  List<String> cat = [];
  List<dynamic> subCat = [];
  List<int> catNum = [];
  List<String> subCatList = [];
  List<int> subCatNum = [];
  TextEditingController txt = TextEditingController();
  var data = jsonDecode('{}');
  Map<String, dynamic> mappedData;
  File file;
  bool duplicate = false;

  @override
  void initState() {
    getRequired();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getDetails() async{
    showLoading();
    String bUrl;
    setState(() {
      active = mappedData['status'] != null ? mappedData['status'] : active;
    });
    setState(() {
      bUrl = mappedData['baseURL'];
      id = mappedData['id'];
      token = mappedData['token'];
      lat = mappedData['lat'];
      lng = mappedData['lng'];
    });
    String url;
    url = bUrl + 'service/listServiceProviders?id=$id';
    await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    ).then((result) {
      if(jsonDecode(result.body)[0] == null) {
        setState(() {
          num = 0;
          data.clear();
        });
      }
      if(jsonDecode(result.body)[0] != null) {
        setState(() {
          num = jsonDecode(result.body).length;
          data = jsonDecode(result.body);
          licenseNumber = jsonDecode(result.body)[0]['license'];
          aadharNumber = jsonDecode(result.body)[0]['aadhar'];
          rating = jsonDecode(result.body)[0]['rating'] != '0.0' ? jsonDecode(result.body)[0]['rating'] : 'Not rated yet';
          active = jsonDecode(result.body)[0]['status'] == 1 ? true : false;
        });
      }
      file.delete();
      mappedData.update('status', (value) => active, ifAbsent: () => active);
      file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
      setState(() {
        mappedData = mappedData;
      });
    }).catchError((onError) {
      print(onError.toString());
    });
    Navigator.pop(context);
  }

  getRequired() async {
    final extDir = await getExternalStorageDirectory();
    String path = '${extDir.path}/details.json';
    file = File(path);
    String data = await file.readAsString();
    mappedData = jsonDecode(data);
    String token = mappedData['token'];
    String bUrl = mappedData['baseURL'];
    await http.get(
      bUrl + 'category/getAllCategories',
      headers: {
        'Authorization': 'Bearer ' + token,
      },
    ).then((res) {
      List<dynamic> list = jsonDecode(res.body);
      cat.clear();
      for (int i = 0; i < list.length; i++) {
        setState(() {
          cat.add(list[i]['name']);
          catNum.add(list[i]['id']);
        });
      }
    });
    await http.get(
      bUrl + 'category/getAllSubCategories',
      headers: {
        'Authorization': 'Bearer ' + token,
      },
    ).then((res) {
      List<dynamic> list = jsonDecode(res.body);
      subCat.clear();
      for (int i = 0; i < list.length; i++) {
        setState(() {
          subCat.add(list[i]);
        });
      }
    });
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Settings'.toUpperCase(),
              style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.white,
              ),
            ),
            centerTitle: false,
            actions: [
              Row(
                children: [
                  Text(
                    active ? 'Service on'.toUpperCase() : 'Service off'.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: active,
                    onChanged: (val) async{
                      file.delete();
                      mappedData.update('status', (value) => val, ifAbsent: () => val);
                      file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
                      setState(() {
                        mappedData = mappedData;
                        active = val;
                      });
                      changeStatus();
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Total Services: $num',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'No.of Orders: 0',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        initialValue: licenseNumber,
                        key: Key(licenseNumber),
                        style: Theme.of(context).textTheme.headline5,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (val) {
                          setState(() {
                            newLicenseNumber = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Aadhar Card NO',
                          labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        initialValue: aadharNumber,
                        key: Key(aadharNumber),
                        maxLength: 12,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        style: Theme.of(context).textTheme.headline5,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (val) {
                          setState(() {
                            newAadharNumber = val;
                          });
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: List.generate(num + 1, (index) {
                        if(index < num) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.all(10),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left:10, right: 10),
                                                    child: Text(
                                                      'Category',
                                                      style: Theme.of(context).textTheme.headline5.copyWith(
                                                        fontWeight: FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth: MediaQuery.of(context).size.width - 100,
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: DropdownButtonFormField(
                                                      value: data[index]['subcategory'],
                                                      items: List.generate(subCat.length, (index) {
                                                        return DropdownMenuItem(
                                                          child: Text(
                                                            subCat[index]['name'],
                                                            style: Theme.of(context).textTheme.headline5,
                                                          ),
                                                          value: subCat[index]['id'],
                                                        );
                                                      }),
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        enabledBorder: InputBorder.none,
                                                      ),
                                                      isDense: true,
                                                      onChanged: (val) {
                                                        for(int i = 0; i < subCat.length; i++) {
                                                          if(subCat[i]['id'] == val) {
                                                            setState(() {
                                                              data[index]['category'] = subCat[i]['category_id'];
                                                              data[index]['service_name'] = subCat[i]['name'];
                                                            });
                                                          }
                                                        }
                                                        setState(() {
                                                          data[index]['subcategory'] = val;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                width: MediaQuery.of(context).size.width,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Min Service Charge',
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
                                                  initialValue: data[index]['charge'],
                                                  style: Theme.of(context).textTheme.headline5,
                                                  keyboardType: TextInputType.number,
                                                  textCapitalization: TextCapitalization.words,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      data[index]['charge'] = val;
                                                    });
                                                  },
                                                  onEditingComplete: () {
                                                    FocusScope.of(context).nextFocus();
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                                  initialValue: data[index]['description'],
                                                  expands: false,
                                                  minLines: 1,
                                                  maxLines: 5,
                                                  style: Theme.of(context).textTheme.headline5,
                                                  keyboardType: TextInputType.text,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      data[index]['description'] = val;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            GestureDetector(
                                              onTap: () {
                                                if(!working) {
                                                  updateService(data[index]['service_id'], index);
                                                }
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
                                                  'Update',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    data[index]['service_name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            data[index]['service_name'],
                                            style: Theme.of(context).textTheme.headline5,
                                          ),
                                          titlePadding: EdgeInsets.all(10),
                                          contentPadding: EdgeInsets.all(10),
                                          content: Text(
                                            'Are you sure to delete this service?',
                                            style: Theme.of(context).textTheme.headline5,
                                          ),
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
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if(!working) {
                                                  deleteService(data[index]['service_id']);
                                                }
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
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              if(aadharNumber == '' && newAadharNumber == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.all(10),
                                      content: Text(
                                          'Enter aadhar number first'
                                      ),
                                    );
                                  },
                                );
                              } else{
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.all(10),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(context).size.width - 100,
                                                ),
                                                padding: EdgeInsets.only(left:10, right: 10),
                                                child: DropdownButtonFormField(
                                                  value: newSelectedSubCat,
                                                  items: List.generate(subCat.length, (index) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                        subCat[index]['name'],
                                                        style: Theme.of(context).textTheme.headline5,
                                                      ),
                                                      value: subCat[index]['id'],
                                                    );
                                                  }),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                  ),
                                                  isDense: true,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      duplicate = false;
                                                    });
                                                    for(int i = 0; i < data.length; i++) {
                                                      if(data[i]['subcategory'] == val) {
                                                        setState(() {
                                                          duplicate = true;
                                                        });
                                                      }
                                                    }
                                                    for(int i = 0; i < subCat.length; i++) {
                                                      if(subCat[i]['id'] == val) {
                                                        setState(() {
                                                          newSelectedCat = subCat[i]['category_id'];
                                                          newServiceName = subCat[i]['name'];
                                                        });
                                                      }
                                                    }
                                                    setState(() {
                                                      newSelectedSubCat = val;
                                                    });
                                                  },
                                                  hint: Text(
                                                    'Category',
                                                    style: Theme.of(context).textTheme.headline5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            width: MediaQuery.of(context).size.width,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Min Service Charge',
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
                                              initialValue: newMinCharge,
                                              style: Theme.of(context).textTheme.headline5,
                                              keyboardType: TextInputType.number,
                                              textCapitalization: TextCapitalization.words,
                                              onChanged: (val) {
                                                setState(() {
                                                  newMinCharge = val;
                                                });
                                              },
                                              onEditingComplete: () {
                                                FocusScope.of(context).nextFocus();
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                              initialValue: newServiceDescription,
                                              expands: false,
                                              minLines: 1,
                                              maxLines: 5,
                                              style: Theme.of(context).textTheme.headline5,
                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization.sentences,
                                              onChanged: (val) {
                                                setState(() {
                                                  newServiceDescription = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      actionsPadding: EdgeInsets.only(right: 10, bottom: 10),
                                      actions: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              working = false;
                                              newServiceName = '';
                                              newMinCharge = '';
                                              newServiceDescription = '';
                                              newSelectedCat = null;
                                              newSelectedSubCat = null;
                                            });
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
                                              style: Theme.of(context).textTheme.headline5.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if(!working && !duplicate) {
                                              addService();
                                            } else if(duplicate) {
                                              Fluttertoast.showToast(
                                                msg: 'Duplicate entry. Cannot create.'
                                              );
                                            }
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
                                              'Add Service',
                                              style: Theme.of(context).textTheme.headline5.copyWith(
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
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Add Service',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    if((newAadharNumber != '' || newLicenseNumber != '') && data != null && !working) {
                      setState(() {
                        updateOnlyAadhar = true;
                      });
                      updateService(data[0]['service_id'], 0);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    margin: EdgeInsets.only(top: 10),
                    color: Theme.of(context).accentColor,
                    child: Center(
                      child: Text(
                        'Update'.toUpperCase(),
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

  updateService(int number, int index) async{
    setState(() {
      working = true;
    });
    String url, bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    url = bUrl + 'service/updateService';
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'id': number,
        'user': id,
        'category': data[index]['category'],
        'subcategory': data[index]['subcategory'],
        'aadhar': newAadharNumber != '' ? int.parse(newAadharNumber) : int.parse(aadharNumber),
        'description': data[index]['description'],
        'charge': int.parse(data[index]['charge'].toString().substring(0, data[index]['charge'].toString().length - 3)),
        'name': data[index]['service_name'],
        'license': newLicenseNumber != '' ? newLicenseNumber : licenseNumber,
      }),
    ).then((res) {
      Fluttertoast.showToast(
        msg: jsonDecode(res.body)['message'],
      );
      getDetails();
      if(!updateOnlyAadhar){
        Navigator.pop(context);
      } else {
        setState(() {
          updateOnlyAadhar = false;
        });
      }
      setState(() {
        working = false;
      });
    });
  }

  deleteService(int number) async{
    setState(() {
      working = true;
    });
    String url, bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    url = bUrl + 'service/deleteService?id=$number';
    await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    ).then((res) {
      Fluttertoast.showToast(
        msg: jsonDecode(res.body)['message'],
      );
      getDetails();
      setState(() {
        working = false;
      });
      Navigator.pop(context);
    });
  }

  addService() async{
    setState(() {
      working = true;
    });
    String url, bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    url = bUrl + 'service/addService';
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'category': newSelectedCat,
        'subcategory': newSelectedSubCat,
        'aadhar': newAadharNumber != '' ? int.parse(newAadharNumber) : int.parse(aadharNumber),
        'description': newServiceDescription,
        'charge': int.parse(newMinCharge),
        'name': newServiceName,
        'license': newLicenseNumber != '' ? newLicenseNumber : licenseNumber,
      }),
    ).then((res) {
      Fluttertoast.showToast(
        msg: jsonDecode(res.body)['message'],
      );
      getDetails();
      setState(() {
        working = false;
        newServiceName = '';
        newMinCharge = '';
        newServiceDescription = '';
        newSelectedCat = null;
        newSelectedSubCat = null;
      });
      Navigator.pop(context);
    });
  }

  changeStatus() async{
    String url, bUrl;
    setState(() {
      bUrl = mappedData['baseURL'];
    });
    url = bUrl + 'service/changeStatus';
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'id': id,
        'status': active ? 1 : 0,
      }),
    ).then((res) {
      Fluttertoast.showToast(
        msg: jsonDecode(res.body)['message'],
      );
      getDetails();
    });
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