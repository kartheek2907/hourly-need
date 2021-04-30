import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loading.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';

List<String> cat = [], subCatList = [], subCatAvatar = [], items = [''], costs = [''];
List<int> subCatNum = [], catNum = [];
List<dynamic> subCat = [];
int sInd, cN = 0, tabIndex = 0, selectedDistIndex = 0, noOfBillItems = 1;
String searchText = '', address = '', location = '', showText = 'Select any service to get the list of services providers.', bUrl = 'http://139.59.4.68/api/v1/', id, curAdd = 'Loading...', street = '', city = '', state = '', country = '', zip = '', _fcmToken, serviceFCMToken, token, orderId, orderDate, orderFrom, orderTo, mainFolderPath;
bool searching = false, fetching = false, gettingService = false, showingOrders = true, showingToday = true, finished = false, gettingItems = false;
Position curLoc;
var txt = TextEditingController();
Map<String, dynamic> mappedData, notificationData;
List<Map<String, dynamic>> ordersData = [], servicesData = [], tOrders = [], tServices = [], serviceProvidersData = [], orderItems = [];
File file, saveFile;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
User _user = FirebaseAuth.instance.currentUser;
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
AwesomeNotifications awesomeNotifications;
LatLng mine;
Timer timer;
List<Widget> list9 = [], list15 = [], list25 = [];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    getMain();
    super.initState();
    awesomeNotifications = AwesomeNotifications();
    awesomeNotifications.initialize(
      '',
      [
        NotificationChannel(
          channelKey: 'hnNotifications',
          channelName: 'hn',
          channelDescription: 'Notifications for HN app',
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );
    awesomeNotifications.cancelAll();
    awesomeNotifications.actionStream.listen((event) async{
      if(event.body.contains('received')) {
        setState(() {
          showingOrders = false;
        });
        DefaultTabController.of(_scaffoldKey.currentContext).animateTo(2);
      }
      if(event.body.contains('sent') || event.body.contains('accepted')) {
        setState(() {
          showingOrders = true;
        });
      }
      if(event.body.contains('completed')) {
        DefaultTabController.of(_scaffoldKey.currentContext).animateTo(3);
        getBillDetails(event.body.substring(event.body.lastIndexOf(' '), event.body.length));
      }
      if(mappedData != null) getMyOrders();
    });
    _firebaseMessaging.requestPermission();
    timer = new Timer.periodic(new Duration(milliseconds: 200), (Timer timer) async {
      this.setState(() {
        orderId = orderId;
        noOfBillItems = noOfBillItems;
      });
      if(finished) {
        getMyOrders();
      }
    });
  }

  Future getMain() async{
    final extDir = await getExternalStorageDirectory();
    setState(() {
      mainFolderPath = extDir.path;
    });
    String path = '${extDir.path}/details.json';
    file = File(path);
    String data = await file.readAsString();
    mappedData = jsonDecode(data);
    showLoadingPopup();
    await _getCurrentLocation();
    await getRequired();
    await getMyDetails();
    getMyOrders();
    Navigator.pop(context);
    if(_fcmToken == null) {
      _firebaseMessaging.getToken().then((value) {
        setState(() {
          _fcmToken = value;
        });
        _firebaseFirestore.collection('users').doc(mappedData['id']).set({
          'uid': _user.uid,
          'id': mappedData['id'],
          'name': mappedData['name'],
          'phone': mappedData['phone'],
          'fcmToken': _fcmToken,
          'time': DateTime.now().toString(),
        }).onError((error, stackTrace) {
          print(error);
        });
      }).onError((error, stackTrace) {
        print(error);
      });
    }
    _firebaseMessaging.subscribeToTopic(mappedData['id']);
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notificationData = message.data;
      });
      RemoteNotification notification = message.notification;
      AndroidNotification androidNotification = message.notification.android;
      Map<String, String> map = {
        "goto": notificationData['goto'].toString(),
      };
      if(notification != null && androidNotification != null) {
        awesomeNotifications.cancelAll();
        awesomeNotifications.createNotification(
          content: NotificationContent(
            id: notification.hashCode,
            channelKey: 'hnNotifications',
            title: notification.title,
            body: notification.body,
            color: Colors.amber,
            payload: map,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      displacement: MediaQuery.of(context).size.height/5,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: SafeArea(
        child: DefaultTabController(
          length: 4,
          initialIndex: tabIndex,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    color: Theme.of(context).accentColor,
                    child: TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).accentColor,
                      indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: (index) {
                        setState(() {
                          tabIndex = index;
                        });
                      },
                      tabs: [
                        Tab(
                          child: Text(
                            'Service',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Search',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Orders',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Invoice',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 140,
                    child: TabBarView(
                      children: [
                        serviceWidget(),
                        searchWidget(),
                        ordersWidget(),
                        invoiceWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white,
                onTap: (index) {
                  if (index == 0) {
                    Navigator.pushNamed(context, 'profile');
                  } else if (index == 1) {
                    Navigator.pushNamed(context, 'settings');
                  } else if (index == 2) {
                    // Navigator.pushNamed(context, 'contact');
                  } else if (index == 3) {
                    // Navigator.pushNamed(context, 'faq');
                  }
                },
                backgroundColor: Theme.of(context).accentColor,
                selectedLabelStyle: Theme.of(context).textTheme.headline6,
                unselectedLabelStyle: Theme.of(context).textTheme.headline6,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline_rounded,
                    ),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings_outlined,
                    ),
                    label: 'Settings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.contact_phone_outlined,
                    ),
                    label: 'Contact Us',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.question_answer_outlined,
                    ),
                    label: 'FAQs',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onRefresh: onRefresh,
    );
  }

  serviceWidget() {
    if(subCatList.isEmpty)
      return ShowLoading();
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          direction: Axis.horizontal,
          children: List.generate(subCatList.length, (index) {
            return GestureDetector(
              onTap: () async{
                setState(() {
                  sInd = index;
                  selectedDistIndex = 0;
                  searching = true;
                  searchText = subCatList[index];
                });
                list9.clear();
                await Future.delayed(Duration(milliseconds: 100));
                txt.text = subCatList[index];
                DefaultTabController.of(_scaffoldKey.currentContext).animateTo(1);
                await Future.delayed(Duration(seconds: 2));
                setState(() {
                  selectedDistIndex = selectedDistIndex;
                });
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 40) / 3,
                height: 90,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: sInd == index ? Theme.of(context).accentColor : Colors.white,
                ),
                child: Column(
                  children: [
                    subCatAvatar[index] != null ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            bUrl + 'image/getImage?image=' + subCatAvatar[index],
                          ),
                          onError: (obj, stTrc) {
                            print(obj);
                          },
                          fit: BoxFit.contain,
                        ),
                      ),
                    ) : Icon(
                      Icons.home_repair_service_outlined,
                      color: sInd == index ? Colors.white : Colors.black,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: (MediaQuery.of(context).size.width - 40) / 3 - 20,
                      ),
                      child: Text(
                        subCatList[index],
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          color: sInd == index ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  searchWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(),
            ),
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.location_on_outlined,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 70,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 70,
                  ),
                  padding: EdgeInsets.all(5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      curAdd,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Within the distance of:',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    selectedDistIndex == 0 ? '9 KM' : selectedDistIndex == 1 ? '15 KM' : '25 KM',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
          ),
          (subCatList.isNotEmpty && !gettingService && txt.text.isNotEmpty) ? serviceList() : txt.text.isEmpty ? Text(
            showText,
            style: Theme.of(context).textTheme.headline5,
          ) : gettingService ? ShowLoading() : Container(),
        ],
      ),
    );
  }

  ordersWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).accentColor.withOpacity(0.2),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, right: 20),
                  width: MediaQuery.of(context).size.width*0.25,
                  child: Text(
                    'Show:',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.75 - 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  'Orders',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Checkbox(
                                value: showingOrders,
                                onChanged: (val) {
                                  setState(() {
                                    showingOrders = !showingOrders;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  'Requests',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Checkbox(
                                value: !showingOrders,
                                onChanged: (val) {
                                  setState(() {
                                    showingOrders = !showingOrders;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.75 - 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  'Today',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Checkbox(
                                value: showingToday,
                                onChanged: (val) {
                                  setState(() {
                                    showingToday = !showingToday;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  'Previous',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Checkbox(
                                value: !showingToday,
                                onChanged: (val) {
                                  setState(() {
                                    showingToday = !showingToday;
                                  });
                                },
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
          ),
          (tOrders != null && tOrders.length != 0 && showingOrders && showingToday) ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Text(
              'Today\'s orders',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : (showingOrders && showingToday) ? Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'No new orders',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : Container(),
          (tOrders != null && tOrders.length != 0 && showingOrders && showingToday) ? Column(
            children: List.generate(tOrders.length, (index) {
              String date = tOrders[tOrders.length - 1 - index]['created_at'].toString().substring(8, 10), month = tOrders[tOrders.length - 1 - index]['created_at'].toString().substring(5, 7), year = tOrders[tOrders.length - 1 - index]['created_at'].toString().substring(0, 4), hour = tOrders[tOrders.length - 1 - index]['created_at'].toString().substring(11, 13), minute = tOrders[tOrders.length - 1 - index]['created_at'].toString().substring(14, 16);
              DateTime value = DateTime.utc(int.parse(year), int.parse(month), int.parse(date), int.parse(hour), int.parse(minute)).toLocal();
              int y = value.year, m = value.month, d = value.day, h = value.hour, min = value.minute;
              String display = '';
              bool isPM = false;
              if(d < 10) {
                display = display + '0$d';
              } else {
                display = display + '$d';
              }
              if(m < 10) {
                display = display + ' - 0$m';
              } else {
                display = display + ' - $m';
              }
              display = display + ' - $y';
              if(h < 10) {
                display = display + ' 0$h';
              } else if(h < 13) {
                display = display + ' $h';
              } else if(h < 24) {
                isPM = true;
                display = display + ' ${h - 12}';
              }
              if(min < 10) {
                display = display + ':0$min';
              } else {
                display = display + ':$min';
              }
              if(isPM) {
                display = display + ' PM';
              } else {
                display = display + ' AM';
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
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
                                    fit: BoxFit.cover,
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
                                    display,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Order Id: ' + tOrders[tOrders.length - 1 - index]['id'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    getName(tOrders[tOrders.length - 1 - index]['service_provider'].toString()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Text(
                          //       '₹500.00',
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .headline5
                          //           .copyWith(
                          //         fontWeight: FontWeight.bold,
                          //         color: Theme.of(context).colorScheme.primary,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 10,
                          //     ),
                          //     Text(
                          //       'Payment via cash',
                          //       style:
                          //       Theme.of(context).textTheme.headline6.copyWith(
                          //         fontWeight: FontWeight.w300,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    tOrders[tOrders.length - 1 - index]['status'] == 'accepted' ? Row(
                      children: [
                        GestureDetector(
                          onTap: () async{
                            file.delete();
                            mappedData.update('trackingId', (value) => tOrders[tOrders.length - 1 - index]['service_provider'], ifAbsent: () => tOrders[tOrders.length - 1 - index]['service_provider']);
                            mappedData.update('iAm', (value) => 'user', ifAbsent: () => 'user');
                            await file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
                            Navigator.pushNamed(context, 'track');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'Track',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cancelOrder(tOrders[tOrders.length - 1 - index]['id'].toString(), tOrders[tOrders.length - 1 - index]['service_provider'].toString());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : tOrders[tOrders.length - 1 - index]['status'] == 'rejected' ? Container(
                      width: MediaQuery.of(context).size.width - 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Rejected by service provider',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ) : tOrders[tOrders.length - 1 - index]['status'] == 'cancelled' ? Container(
                      width: MediaQuery.of(context).size.width - 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Cancelled by you',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ) : tOrders[tOrders.length - 1 - index]['status'] == 'requested' ? GestureDetector(
                      onTap: () {
                        cancelOrder(tOrders[tOrders.length - 1 - index]['id'].toString(), tOrders[tOrders.length - 1 - index]['service_provider'].toString());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Service requested (Tap to cancel)',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ) : tOrders[tOrders.length - 1 - index]['status'] == 'completed' ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              orderId = tOrders[tOrders.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = tOrders[tOrders.length - 1 - index]['service_provider'].toString();
                              orderTo = tOrders[tOrders.length - 1 - index]['user'].toString();
                            });
                            getOrderItems(orderId);
                            DefaultTabController.of(_scaffoldKey.currentContext).animateTo(3);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'View',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              orderId = tOrders[tOrders.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = tOrders[tOrders.length - 1 - index]['service_provider'].toString();
                              orderTo = tOrders[tOrders.length - 1 - index]['user'].toString();
                            });
                            await getOrderItems(orderId);
                            await saveAsPDF(orderId, orderDate, orderFrom, orderTo);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'PDF',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),
                  ],
                ),
              );
            }),
          ) : Container(),
          (ordersData != null && ordersData.length != tOrders.length && showingOrders && !showingToday) ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Text(
              'Previous orders',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : (showingOrders && !showingToday) ? Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'No previous orders',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : Container(),
          (ordersData != null && ordersData.length != tOrders.length && showingOrders && !showingToday) ? Column(
            children: List.generate(ordersData.length, (index) {
              String date = ordersData[ordersData.length - 1 - index]['created_at'].toString().substring(8, 10), month = ordersData[ordersData.length - 1 - index]['created_at'].toString().substring(5, 7), year = ordersData[ordersData.length - 1 - index]['created_at'].toString().substring(0, 4), hour = ordersData[ordersData.length - 1 - index]['created_at'].toString().substring(11, 13), minute = ordersData[ordersData.length - 1 - index]['created_at'].toString().substring(14, 16);
              DateTime value = DateTime.utc(int.parse(year), int.parse(month), int.parse(date), int.parse(hour), int.parse(minute)).toLocal();
              int y = value.year, m = value.month, d = value.day, h = value.hour, min = value.minute;
              String display = '';
              bool isPM = false;
              if(d < 10) {
                display = display + '0$d';
              } else {
                display = display + '$d';
              }
              if(m < 10) {
                display = display + ' - 0$m';
              } else {
                display = display + ' - $m';
              }
              display = display + ' - $y';
              if(h < 10) {
                display = display + ' 0$h';
              } else if(h < 13) {
                display = display + ' $h';
              } else if(h < 24) {
                isPM = true;
                display = display + ' ${h - 12}';
              }
              if(min < 10) {
                display = display + ':0$min';
              } else {
                display = display + ':$min';
              }
              if(isPM) {
                display = display + ' PM';
              } else {
                display = display + ' AM';
              }
              if(tOrders.contains(ordersData[ordersData.length - 1 - index]))
                return Container();
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
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
                                    fit: BoxFit.cover,
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
                                    display,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Order Id: ' + ordersData[ordersData.length - 1 - index]['id'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    getName(ordersData[ordersData.length - 1 - index]['service_provider'].toString()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              orderId = ordersData[ordersData.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = ordersData[ordersData.length - 1 - index]['service_provider'].toString();
                              orderTo = ordersData[ordersData.length - 1 - index]['user'].toString();
                            });
                            getOrderItems(orderId);
                            DefaultTabController.of(_scaffoldKey.currentContext).animateTo(3);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'View',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              orderId = ordersData[ordersData.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = ordersData[ordersData.length - 1 - index]['service_provider'].toString();
                              orderTo = ordersData[ordersData.length - 1 - index]['user'].toString();
                            });
                            await getOrderItems(orderId);
                            await saveAsPDF(orderId, orderDate, orderFrom, orderTo);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'PDF',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ) : Container(),
          (tServices != null && tServices.length != 0 && !showingOrders && showingToday) ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Text(
              'Today\'s Services',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : (!showingOrders && showingToday) ? Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'No new requests',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : Container(),
          (tServices != null && tServices.length != 0 && !showingOrders && showingToday) ? Column(
            children: List.generate(tServices.length, (index) {
              String date = tServices[tServices.length - 1 - index]['created_at'].toString().substring(8, 10), month = tServices[tServices.length - 1 - index]['created_at'].toString().substring(5, 7), year = tServices[tServices.length - 1 - index]['created_at'].toString().substring(0, 4), hour = tServices[tServices.length - 1 - index]['created_at'].toString().substring(11, 13), minute = tServices[tServices.length - 1 - index]['created_at'].toString().substring(14, 16);
              DateTime value = DateTime.utc(int.parse(year), int.parse(month), int.parse(date), int.parse(hour), int.parse(minute)).toLocal();
              int y = value.year, m = value.month, d = value.day, h = value.hour, min = value.minute;
              String display = '';
              bool isPM = false;
              if(d < 10) {
                display = display + '0$d';
              } else {
                display = display + '$d';
              }
              if(m < 10) {
                display = display + ' - 0$m';
              } else {
                display = display + ' - $m';
              }
              display = display + ' - $y';
              if(h < 10) {
                display = display + ' 0$h';
              } else if(h < 13) {
                display = display + ' $h';
              } else if(h < 24) {
                isPM = true;
                display = display + ' ${h - 12}';
              }
              if(min < 10) {
                display = display + ':0$min';
              } else {
                display = display + ':$min';
              }
              if(isPM) {
                display = display + ' PM';
              } else {
                display = display + ' AM';
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
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
                                    fit: BoxFit.cover,
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
                                    display,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Order Id: ' + tServices[tServices.length - 1 - index]['id'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    getName(tServices[tServices.length - 1 - index]['user'].toString()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Text(
                          //       '₹500.00',
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .headline5
                          //           .copyWith(
                          //         fontWeight: FontWeight.bold,
                          //         color: Theme.of(context).colorScheme.primary,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 10,
                          //     ),
                          //     Text(
                          //       'Payment via cash',
                          //       style:
                          //       Theme.of(context).textTheme.headline6.copyWith(
                          //         fontWeight: FontWeight.w300,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    tServices[tServices.length - 1 - index]['status'] == 'accepted' ? Row(
                      children: [
                        GestureDetector(
                          onTap: () async{
                            file.delete();
                            mappedData.update('trackingId', (value) => tOrders[tServices.length - 1 - index]['service_provider'], ifAbsent: () => tOrders[tServices.length - 1 - index]['service_provider']);
                            mappedData.update('iAm', (value) => 'server', ifAbsent: () => 'server');
                            await file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
                            Navigator.pushNamed(context, 'track');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'Navigate',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showAddBillDetailsPopup(tServices[tServices.length - 1 - index]['id'].toString(), tServices[tServices.length - 1 - index]['user'].toString());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'Finish order',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : tServices[tServices.length - 1 - index]['status'] == 'rejected' ? Container(
                      width: MediaQuery.of(context).size.width - 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Rejected by you',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ) : tServices[tServices.length - 1 - index]['status'] == 'cancelled' ? Container(
                      width: MediaQuery.of(context).size.width - 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Cancelled by user',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ) : tServices[tServices.length - 1 - index]['status'] == 'requested' ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            acceptOrder(tServices[tServices.length - 1 - index]['id'].toString(), tServices[tServices.length - 1 - index]['user'].toString());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'Accept',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            rejectOrder(tServices[tServices.length - 1 - index]['id'].toString(), tServices[tServices.length - 1 - index]['user'].toString());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'Reject',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : tServices[tServices.length - 1 - index]['status'] == 'completed' ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              orderId = tServices[tServices.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = tServices[tServices.length - 1 - index]['service_provider'].toString();
                              orderTo = tServices[tServices.length - 1 - index]['user'].toString();
                            });
                            getOrderItems(orderId);
                            DefaultTabController.of(_scaffoldKey.currentContext).animateTo(3);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'View',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              orderId = tServices[tServices.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = tServices[tServices.length - 1 - index]['service_provider'].toString();
                              orderTo = tServices[tServices.length - 1 - index]['user'].toString();
                            });
                            await getOrderItems(orderId);
                            await saveAsPDF(orderId, orderDate, orderFrom, orderTo);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'PDF',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),
                  ],
                ),
              );
            }),
          ) : Container(),
          (servicesData != null && servicesData.length != tServices.length && !showingOrders && !showingToday) ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Text(
              'Previous Services',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : (!showingOrders && !showingToday) ? Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'No previous services',
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : Container(),
          (servicesData != null && servicesData.length != tServices.length && !showingOrders && !showingToday) ? Column(
            children: List.generate(servicesData.length, (index) {
              String date = servicesData[servicesData.length - 1 - index]['created_at'].toString().substring(8, 10), month = servicesData[servicesData.length - 1 - index]['created_at'].toString().substring(5, 7), year = servicesData[servicesData.length - 1 - index]['created_at'].toString().substring(0, 4), hour = servicesData[servicesData.length - 1 - index]['created_at'].toString().substring(11, 13), minute = servicesData[servicesData.length - 1 - index]['created_at'].toString().substring(14, 16);
              DateTime value = DateTime.utc(int.parse(year), int.parse(month), int.parse(date), int.parse(hour), int.parse(minute)).toLocal();
              int y = value.year, m = value.month, d = value.day, h = value.hour, min = value.minute;
              String display = '';
              bool isPM = false;
              if(d < 10) {
                display = display + '0$d';
              } else {
                display = display + '$d';
              }
              if(m < 10) {
                display = display + ' - 0$m';
              } else {
                display = display + ' - $m';
              }
              display = display + ' - $y';
              if(h < 10) {
                display = display + ' 0$h';
              } else if(h < 13) {
                display = display + ' $h';
              } else if(h < 24) {
                isPM = true;
                display = display + ' ${h - 12}';
              }
              if(min < 10) {
                display = display + ':0$min';
              } else {
                display = display + ':$min';
              }
              if(isPM) {
                display = display + ' PM';
              } else {
                display = display + ' AM';
              }
              if(tServices.contains(servicesData[servicesData.length - 1 - index]))
                return Container();
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
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
                                    fit: BoxFit.cover,
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
                                    display,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Order Id: ' + servicesData[servicesData.length - 1 - index]['id'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    getName(servicesData[servicesData.length - 1 - index]['user'].toString()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Text(
                          //       '₹500.00',
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .headline5
                          //           .copyWith(
                          //         fontWeight: FontWeight.bold,
                          //         color: Theme.of(context).colorScheme.primary,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 10,
                          //     ),
                          //     Text(
                          //       'Payment via cash',
                          //       style:
                          //       Theme.of(context).textTheme.headline6.copyWith(
                          //         fontWeight: FontWeight.w300,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              orderId = servicesData[servicesData.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = servicesData[servicesData.length - 1 - index]['service_provider'].toString();
                              orderTo = servicesData[servicesData.length - 1 - index]['user'].toString();
                            });
                            getOrderItems(orderId);
                            DefaultTabController.of(_scaffoldKey.currentContext).animateTo(3);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'View',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              orderId = servicesData[servicesData.length - 1 - index]['id'].toString();
                              orderDate = display;
                              orderFrom = servicesData[servicesData.length - 1 - index]['service_provider'].toString();
                              orderTo = servicesData[servicesData.length - 1 - index]['user'].toString();
                            });
                            await getOrderItems(orderId);
                            await saveAsPDF(orderId, orderDate, orderFrom, orderTo);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2 - 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text(
                                'PDF',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ) : Container(),
        ],
      ),
    );
  }

  invoiceWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: orderId != null ? Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2 - 10,
                    minWidth: MediaQuery.of(context).size.width / 2 - 10,
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID:\t\t',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                      Text(
                        '$orderId'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2 - 10,
                    minWidth: MediaQuery.of(context).size.width / 2 - 10,
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date:\t\t',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                      Text(
                        '$orderDate'.substring(0, 14),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2 - 10,
                    minWidth: MediaQuery.of(context).size.width / 2 - 10,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From:',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${getName(orderFrom)},\n${getDetails(orderFrom)}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2 - 10,
                    minWidth: MediaQuery.of(context).size.width / 2 - 10,
                  ),
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To:\t\t\t\t\t\t\t\t\t\t\t\t\t\t',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${getName(orderTo)},\n${getDetails(orderTo)}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            gettingItems ? ShowLoading() : Table(
              border: TableBorder.all(
                color: Theme.of(context).accentColor.withOpacity(0.5),
                width: 2,
                style: BorderStyle.solid,
              ),
              children: getTable(),
            ),
            // Table(
            //   border: TableBorder.all(
            //     color: Color(0xFFDCDCDC),
            //     width: 1,
            //     style: BorderStyle.solid,
            //   ),
            //   children: [
            //     TableRow(
            //       children: [
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 3,
            //             maxWidth: MediaQuery.of(context).size.width / 3,
            //           ),
            //           child: Text(
            //             'Item/Work',
            //             style: Theme.of(context).textTheme.headline5.copyWith(
            //               fontWeight: FontWeight.bold,
            //               decoration: TextDecoration.underline,
            //               decorationStyle: TextDecorationStyle.solid,
            //             ),
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 5,
            //             maxWidth: MediaQuery.of(context).size.width / 5,
            //           ),
            //           child: Text(
            //             'Quantity',
            //             style: Theme.of(context).textTheme.headline5.copyWith(
            //               fontWeight: FontWeight.bold,
            //               decoration: TextDecoration.underline,
            //               decorationStyle: TextDecorationStyle.solid,
            //             ),
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 5,
            //             maxWidth: MediaQuery.of(context).size.width / 5,
            //           ),
            //           child: Text(
            //             'Unit Price',
            //             style: Theme.of(context).textTheme.headline5.copyWith(
            //               fontWeight: FontWeight.bold,
            //               decoration: TextDecoration.underline,
            //               decorationStyle: TextDecorationStyle.solid,
            //             ),
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 4.8,
            //             maxWidth: MediaQuery.of(context).size.width / 4.8,
            //           ),
            //           child: Text(
            //             'Item/Work Price',
            //             style: Theme.of(context).textTheme.headline5.copyWith(
            //               fontWeight: FontWeight.bold,
            //               decoration: TextDecoration.underline,
            //               decorationStyle: TextDecorationStyle.solid,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     TableRow(
            //       children: [
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 3,
            //             maxWidth: MediaQuery.of(context).size.width / 3,
            //           ),
            //           child: Text(
            //             'Water leakage fixed',
            //             style: Theme.of(context).textTheme.headline5,
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 5,
            //             maxWidth: MediaQuery.of(context).size.width / 5,
            //           ),
            //           child: Text(
            //             '2',
            //             style: Theme.of(context).textTheme.headline5,
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 5,
            //             maxWidth: MediaQuery.of(context).size.width / 5,
            //           ),
            //           child: Text(
            //             '₹150',
            //             style: Theme.of(context).textTheme.headline5,
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 4.8,
            //             maxWidth: MediaQuery.of(context).size.width / 4.8,
            //           ),
            //           child: Text(
            //             '₹300',
            //             style: Theme.of(context).textTheme.headline5.copyWith(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     TableRow(
            //       children: [
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 3,
            //             maxWidth: MediaQuery.of(context).size.width / 3,
            //           ),
            //           child: Text(
            //             'Taps',
            //             style: Theme.of(context).textTheme.headline5,
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 5,
            //             maxWidth: MediaQuery.of(context).size.width / 5,
            //           ),
            //           child: Text(
            //             '2',
            //             style: Theme.of(context).textTheme.headline5,
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 5,
            //             maxWidth: MediaQuery.of(context).size.width / 5,
            //           ),
            //           child: Text(
            //             '₹100',
            //             style: Theme.of(context).textTheme.headline5,
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           constraints: BoxConstraints(
            //             minWidth: MediaQuery.of(context).size.width / 4.8,
            //             maxWidth: MediaQuery.of(context).size.width / 4.8,
            //           ),
            //           child: Text(
            //             '₹200',
            //             style: Theme.of(context).textTheme.headline5.copyWith(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     TableRow(children: [
            //       Container(),
            //       Container(),
            //       Container(
            //         padding: EdgeInsets.all(5),
            //         constraints: BoxConstraints(
            //           minWidth: MediaQuery.of(context).size.width * 5,
            //           maxWidth: MediaQuery.of(context).size.width * 5,
            //         ),
            //         child: Center(
            //           child: Text(
            //             'Total Bill:',
            //             style: Theme.of(context).textTheme.headline5.copyWith(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.all(5),
            //         constraints: BoxConstraints(
            //           minWidth: MediaQuery.of(context).size.width / 4.8,
            //           maxWidth: MediaQuery.of(context).size.width / 4.8,
            //         ),
            //         child: Text(
            //           '₹500',
            //           style: Theme.of(context).textTheme.headline5.copyWith(
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ]),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async{
                    showLoadingPopup();
                    await saveAsPDF(orderId, orderDate, '${getName(orderFrom)},\n${getDetails(orderFrom)}', '${getName(orderTo)},\n${getDetails(orderTo)}');
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 0, top: 15),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      'Save as PDF',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ) : Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            'Tap on view in orders page for the invoice',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        curLoc = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    final coordinates = new Coordinates(curLoc.latitude, curLoc.longitude);
    var addresses;
    await Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) async{
      setState(() {
        addresses = value;
      });
    }).catchError((onError) {
      print(onError);
    });
    setState(() {
      curAdd = addresses.first.addressLine;
      location = addresses.first.addressLine;
    });
    file.delete();
    mappedData.update('location', (value) => curAdd, ifAbsent: () => curAdd);
    mappedData.update('street', (value) => addresses.first.featureName, ifAbsent: () => addresses.first.featureName);
    mappedData.update('city', (value) => addresses.first.locality, ifAbsent: () => addresses.first.locality);
    mappedData.update('state', (value) => addresses.first.adminArea, ifAbsent: () => addresses.first.adminArea);
    mappedData.update('country', (value) => addresses.first.countryName, ifAbsent: () => addresses.first.countryName);
    mappedData.update('zip', (value) => addresses.first.postalCode, ifAbsent: () => addresses.first.postalCode);
    mappedData.update('lat', (value) => coordinates.latitude, ifAbsent: () => coordinates.latitude);
    mappedData.update('lng', (value) => coordinates.longitude, ifAbsent: () => coordinates.longitude);
    file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
    await getService();
    setState(() {
      mappedData = mappedData;
    });
  }

  Future getRequired() async {
    String token = mappedData['token'];
    setState(() {
      id = mappedData['id'];
      street = mappedData['street'] != null ? mappedData['street'] : '';
      city = mappedData['city'] != null ? mappedData['city'] : '';
      state = mappedData['state'] != null ? mappedData['state'] : '';
      country = mappedData['country'] != null ? mappedData['country'] : '';
      zip = mappedData['zip'] != null ? mappedData['zip'] : '';
    });
    file.delete();
    mappedData.update('address', (value) => street + ', ' + city + ', ' + state + ', ' + country + ' - ' + zip, ifAbsent: () => street + ', ' + city + ', ' + state + ', ' + country + ' - ' + zip);
    setState(() {
      address = mappedData['address'];
      mappedData = mappedData;
    });
    file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
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
      getSubCat();
    });
  }

  getSubCat() {
    subCatList.clear();
    subCatNum.clear();
    subCatAvatar.clear();
    for (int i = 0; i < subCat.length; i++) {
      setState(() {
        subCatList.add(subCat[i]['name']);
        subCatNum.add(subCat[i]['category_id']);
        subCatAvatar.add(subCat[i]['avatar']);
      });
    }
  }

  Future getMyDetails() async {
    String url, mobile = mappedData['phone'];
    setState(() {
      url = bUrl + 'user/login';
    });
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'mobile': mobile.replaceAll('+91', ''),
      }),
    ).then((result) {
      file.delete();
      mappedData.update('isLoggedIn', (value) => true, ifAbsent: () => true);
      mappedData.update('token', (value) => jsonDecode(result.body)['token'], ifAbsent: () => jsonDecode(result.body)['token']);
      mappedData.update('id', (value) => jsonDecode(result.body)['id'].toString(), ifAbsent: () => jsonDecode(result.body)['id'].toString());
      mappedData.update('hno', (value) => jsonDecode(result.body)['hno'].toString(), ifAbsent: () => jsonDecode(result.body)['hno'].toString());
      mappedData.update('street', (value) => jsonDecode(result.body)['street'], ifAbsent: () => jsonDecode(result.body)['street']);
      mappedData.update('country', (value) => jsonDecode(result.body)['country'], ifAbsent: () => jsonDecode(result.body)['country']);
      mappedData.update('state', (value) => jsonDecode(result.body)['state'], ifAbsent: () => jsonDecode(result.body)['state']);
      mappedData.update('city', (value) => jsonDecode(result.body)['city'], ifAbsent: () => jsonDecode(result.body)['city']);
      mappedData.update('state', (value) => jsonDecode(result.body)['state'], ifAbsent: () => jsonDecode(result.body)['state']);
      mappedData.update('zip', (value) => jsonDecode(result.body)['zip'].toString(), ifAbsent: () => jsonDecode(result.body)['zip'].toString());
      file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
      setState(() {
        mappedData = mappedData;
      });
    });
  }

  getMyOrders() async{
    String url;
    setState(() {
      url = bUrl + 'order/listOrders';
    });
    await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + mappedData['token'],
      },
    ).then((res) {
      ordersData.clear();
      servicesData.clear();
      for(int i = 0; i < jsonDecode(res.body).length; i++) {
        if(jsonDecode(res.body)[i]['user'].toString() == mappedData['id'].toString())
          ordersData.add(jsonDecode(res.body)[i]);
        if(jsonDecode(res.body)[i]['service_provider'].toString() == mappedData['id'].toString())
          servicesData.add(jsonDecode(res.body)[i]);
      }
      setState(() {
        ordersData = ordersData;
        servicesData = servicesData;
      });
    }).whenComplete(() {
      tOrders.clear();
      tServices.clear();
      int tDay = DateTime.now().day, tMonth = DateTime.now().month, tYear = DateTime.now().year;
      for(int i = 0; i < ordersData.length; i++) {
        String date = ordersData[i]['created_at'].toString().substring(8, 10), month = ordersData[i]['created_at'].toString().substring(5, 7), year = ordersData[i]['created_at'].toString().substring(0, 4), hour = ordersData[i]['created_at'].toString().substring(11, 13), minute = ordersData[i]['created_at'].toString().substring(14, 16);
        DateTime value = DateTime.utc(int.parse(year), int.parse(month), int.parse(date), int.parse(hour), int.parse(minute)).toLocal();
        if(value.day == tDay && value.month == tMonth && value.year == tYear) {
          tOrders.add(ordersData[i]);
        }
      }
      for(int i = 0; i < servicesData.length; i++) {
        String date = servicesData[i]['created_at'].toString().substring(8, 10), month = servicesData[i]['created_at'].toString().substring(5, 7), year = servicesData[i]['created_at'].toString().substring(0, 4), hour = servicesData[i]['created_at'].toString().substring(11, 13), minute = servicesData[i]['created_at'].toString().substring(14, 16);
        DateTime value = DateTime.utc(int.parse(year), int.parse(month), int.parse(date), int.parse(hour), int.parse(minute)).toLocal();
        if(value.day == tDay && value.month == tMonth && value.year == tYear) {
          tServices.add(servicesData[i]);
        }
      }
      setState(() {
        finished = false;
      });
    });
  }

  acceptOrder(String orderId, String userId) async{
    String url;
    setState(() {
      url = bUrl + 'order/updateOrder';
    });
    await _firebaseFirestore.collection('users').doc(userId).get().then((value) {
      serviceFCMToken = value.data()['fcmToken'];
    });
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + mappedData['token'],
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'id': orderId,
        'status': 'accepted',
      }),
    ).then((value) async{
      if(jsonDecode(value.body)['message'].toString().contains('updated')) {
        await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAH13n1BU:APA91bHccnUDikZ9s9ioBEjIQnzGx2hCfkZNil62hFfgKo8rmQ6FJnHm32snXdLc2TKHnldpCN_1Qn1Ie530VpFVJXdN29MyVyMXoT6kQITN9DzaJRYrv1ORjn8cSe2Tv1C45wdGg2z_',
          },
          body: jsonEncode(<String, dynamic> {
            "notification": {
              "title": "Order Accepted",
              "body": "Order Accepted by ${mappedData['name']}",
            },
            "priority": "high",
            "data": {
              
            },
            "to": "$serviceFCMToken"
          }),
        ).then((value) {
          if(jsonDecode(value.body)['results'][0]['message_id'] != null) {
            Fluttertoast.showToast(
              msg: 'Order accepted successfully',
            );
          }
          awesomeNotifications.cancelAll();
        }).catchError((onError) {
          Fluttertoast.showToast(
            msg: onError.toString(),
          );
        });
        await http.post(
          url,
          headers: <String, String>{
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic> {
            'id': id,
            'status': 0,
          }),
        );
        getMyOrders();
      }
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
    });
  }

  rejectOrder(String orderId, String userId) async{
    String url;
    setState(() {
      url = bUrl + 'order/updateOrder';
    });
    await _firebaseFirestore.collection('users').doc(userId).get().then((value) {
      serviceFCMToken = value.data()['fcmToken'];
    });
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + mappedData['token'],
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'id': orderId,
        'status': 'rejected',
      }),
    ).then((value) async{
      if(jsonDecode(value.body)['message'].toString().contains('updated')) {
        await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAH13n1BU:APA91bHccnUDikZ9s9ioBEjIQnzGx2hCfkZNil62hFfgKo8rmQ6FJnHm32snXdLc2TKHnldpCN_1Qn1Ie530VpFVJXdN29MyVyMXoT6kQITN9DzaJRYrv1ORjn8cSe2Tv1C45wdGg2z_',
          },
          body: jsonEncode(<String, dynamic> {
            "notification": {
              "title": "Order Rejected",
              "body": "Order Rejected by ${mappedData['name']}",
            },
            "priority": "high",
            "data": {

            },
            "to": "$serviceFCMToken"
          }),
        ).then((value) {
          if(jsonDecode(value.body)['results'][0]['message_id'] != null) {
            Fluttertoast.showToast(
              msg: 'Order cancelled successfully',
            );
          }
          awesomeNotifications.cancelAll();
        }).catchError((onError) {
          Fluttertoast.showToast(
            msg: onError.toString(),
          );
        });
        getMyOrders();
      }
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
    });
  }

  cancelOrder(String orderId, String serviceId) async{
    String url;
    setState(() {
      url = bUrl + 'order/updateOrder';
    });
    await _firebaseFirestore.collection('users').doc(serviceId).get().then((value) {
      serviceFCMToken = value.data()['fcmToken'];
    });
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + mappedData['token'],
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'id': orderId,
        'status': 'cancelled',
      }),
    ).then((value) async{
      if(jsonDecode(value.body)['message'].toString().contains('updated')) {
        await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAH13n1BU:APA91bHccnUDikZ9s9ioBEjIQnzGx2hCfkZNil62hFfgKo8rmQ6FJnHm32snXdLc2TKHnldpCN_1Qn1Ie530VpFVJXdN29MyVyMXoT6kQITN9DzaJRYrv1ORjn8cSe2Tv1C45wdGg2z_',
          },
          body: jsonEncode(<String, dynamic> {
            "notification": {
              "title": "Order Cancelled",
              "body": "Order Cancelled by ${mappedData['name']}",
            },
            "priority": "high",
            "data": {

            },
            "to": "$serviceFCMToken"
          }),
        ).then((value) {
          if(jsonDecode(value.body)['results'][0]['message_id'] != null) {
            Fluttertoast.showToast(
              msg: 'Order cancelled successfully',
            );
          }
          awesomeNotifications.cancelAll();
        }).catchError((onError) {
          Fluttertoast.showToast(
            msg: onError.toString(),
          );
        });
        getMyOrders();
      }
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
    });
  }

  Future getService() async {
    setState(() {
      gettingService = true;
    });
    setState(() {
      token = mappedData['token'];
      mine = LatLng(mappedData['lat'], mappedData['lng']);
    });
    String url = bUrl + 'service/listServiceProviders';
    await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    ).then((value) {
      serviceProvidersData.clear();
      for(int i = 0; i < jsonDecode(value.body).length; i++) {
        serviceProvidersData.add(jsonDecode(value.body)[i]);
      }
      list9.clear();
      list15.clear();
      list25.clear();
      for(int i = 0; i < jsonDecode(value.body).length; i++) {
        if(jsonDecode(value.body)[i]['id'].toString() != id)
          if(jsonDecode(value.body)[i]['subcategory_name'] == searchText && jsonDecode(value.body)[i]['lat'] != null && jsonDecode(value.body)[i]['status'].toString() == 1.toString()) {
            if(double.parse(calculateDistance(mine, LatLng(double.parse(jsonDecode(value.body)[i]['lat']), double.parse(jsonDecode(value.body)[i]['lng'])))) < 9) {
              list9.add(
                Container(
                  margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                        Theme.of(context).colorScheme.secondary.withOpacity(0.7),
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
                                    image: jsonDecode(value.body)[i]['avatar'] != null ? DecorationImage(
                                      image: NetworkImage(
                                          bUrl + 'image/getImage?image=' + jsonDecode(value.body)[i]['avatar']
                                      ),
                                      fit: BoxFit.cover,
                                    ) : DecorationImage(
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
                                      jsonDecode(value.body)[i]['name']
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    jsonDecode(value.body)[i]['rating'] != '0.0' ? Text(
                                      'Rating: ' + jsonDecode(value.body)[i]['rating'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '₹' + jsonDecode(value.body)[i]['charge'],
                              style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showConfirmSend(mappedData['id'].toString(), jsonDecode(value.body)[i]['id'].toString(), sInd.toString());
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Hire',
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () async{
                          //     file.delete();
                          //     mappedData.update('trackingId', (val) => jsonDecode(value.body)[i]['id'], ifAbsent: () => jsonDecode(value.body)[i]['id']);
                          //     mappedData.update('iAm', (value) => 'user', ifAbsent: () => 'user');
                          //     await file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
                          //     Navigator.pushNamed(context, 'track');
                          //   },
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width/2 - 9,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         bottomRight: Radius.circular(10),
                          //       ),
                          //       color: Theme.of(context).accentColor,
                          //       border: Border.all(
                          //         width: 2,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     padding: EdgeInsets.symmetric(vertical: 15),
                          //     child: Center(
                          //       child: Text(
                          //         'Track',
                          //         style: Theme.of(context).textTheme.headline5.copyWith(
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            if(double.parse(calculateDistance(mine, LatLng(double.parse(jsonDecode(value.body)[i]['lat']), double.parse(jsonDecode(value.body)[i]['lng'])))) > 9 && double.parse(calculateDistance(mine, LatLng(double.parse(jsonDecode(value.body)[i]['lat']), double.parse(jsonDecode(value.body)[i]['lng'])))) < 15) {
              list15.add(
                Container(
                  margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                        Theme.of(context).colorScheme.secondary.withOpacity(0.7),
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
                                    image: jsonDecode(value.body)[i]['avatar'] != null ? DecorationImage(
                                      image: NetworkImage(
                                          bUrl + 'image/getImage?image=' + jsonDecode(value.body)[i]['avatar']
                                      ),
                                      fit: BoxFit.cover,
                                    ) : DecorationImage(
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
                                      jsonDecode(value.body)[i]['name']
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    jsonDecode(value.body)[i]['rating'] != '0.0' ? Text(
                                      'Rating: ' + jsonDecode(value.body)[i]['rating'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '₹' + jsonDecode(value.body)[i]['charge'],
                              style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showConfirmSend(mappedData['id'].toString(), jsonDecode(value.body)[i]['id'].toString(), sInd.toString());
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Hire',
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () async{
                          //     file.delete();
                          //     mappedData.update('trackingId', (val) => jsonDecode(value.body)[i]['id'], ifAbsent: () => jsonDecode(value.body)[i]['id']);
                          //     mappedData.update('iAm', (value) => 'user', ifAbsent: () => 'user');
                          //     await file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
                          //     Navigator.pushNamed(context, 'track');
                          //   },
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width/2 - 9,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         bottomRight: Radius.circular(10),
                          //       ),
                          //       color: Theme.of(context).accentColor,
                          //       border: Border.all(
                          //         width: 2,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     padding: EdgeInsets.symmetric(vertical: 15),
                          //     child: Center(
                          //       child: Text(
                          //         'Track',
                          //         style: Theme.of(context).textTheme.headline5.copyWith(
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            if(double.parse(calculateDistance(mine, LatLng(double.parse(jsonDecode(value.body)[i]['lat']), double.parse(jsonDecode(value.body)[i]['lng'])))) > 15 && double.parse(calculateDistance(mine, LatLng(double.parse(jsonDecode(value.body)[i]['lat']), double.parse(jsonDecode(value.body)[i]['lng'])))) < 25) {
              list25.add(
                Container(
                  margin: EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                        Theme.of(context).colorScheme.secondary.withOpacity(0.7),
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
                                    image: jsonDecode(value.body)[i]['avatar'] != null ? DecorationImage(
                                      image: NetworkImage(
                                          bUrl + 'image/getImage?image=' + jsonDecode(value.body)[i]['avatar']
                                      ),
                                      fit: BoxFit.cover,
                                    ) : DecorationImage(
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
                                      jsonDecode(value.body)[i]['name']
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    jsonDecode(value.body)[i]['rating'] != '0.0' ? Text(
                                      'Rating: ' + jsonDecode(value.body)[i]['rating'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '₹' + jsonDecode(value.body)[i]['charge'],
                              style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showConfirmSend(mappedData['id'].toString(), jsonDecode(value.body)[i]['id'].toString(), sInd.toString());
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  'Hire',
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () async{
                          //     file.delete();
                          //     mappedData.update('trackingId', (val) => jsonDecode(value.body)[i]['id'], ifAbsent: () => jsonDecode(value.body)[i]['id']);
                          //     mappedData.update('iAm', (value) => 'user', ifAbsent: () => 'user');
                          //     await file.writeAsString(jsonEncode(mappedData), mode: FileMode.append);
                          //     Navigator.pushNamed(context, 'track');
                          //   },
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width/2 - 9,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         bottomRight: Radius.circular(10),
                          //       ),
                          //       color: Theme.of(context).accentColor,
                          //       border: Border.all(
                          //         width: 2,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     padding: EdgeInsets.symmetric(vertical: 15),
                          //     child: Center(
                          //       child: Text(
                          //         'Track',
                          //         style: Theme.of(context).textTheme.headline5.copyWith(
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }
      }
      setState(() {
        fetching = false;
        list9 = list9;
        list15 = list15;
        list25 = list25;
      });
      if(list9.isNotEmpty) {
        setState(() {
          selectedDistIndex = 0;
        });
      } else if(list15.isNotEmpty) {
        setState(() {
          selectedDistIndex = 1;
        });
      } else if(list25.isNotEmpty) {
        setState(() {
          selectedDistIndex = 2;
        });
      } else {
        setState(() {
          selectedDistIndex = 3;
        });
      }
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
      print(onError);
    });
    setState(() {
      gettingService = false;
    });
  }

  calculateDistance(LatLng latLngA, LatLng latLngB) {
    double dist;
    dist = 6378.137*(acos(sin(latLngA.latitude*pi/180)*sin(latLngB.latitude*pi/180) + cos(latLngA.latitude*pi/180)*cos(latLngB.latitude*pi/180)*cos((latLngA.longitude - latLngB.longitude)*pi/180)));
    return ((dist.ceil() + dist.floor())/2).toString();
  }

  sendOrder(String myId, String serviceId, String subCatId) async{
    DateTime _dateTime = DateTime.now();
    await _firebaseFirestore.collection('users').doc(serviceId).get().then((value) {
      serviceFCMToken = value.data()['fcmToken'];
    });
    String path = _firebaseFirestore.collection('users').doc(myId).collection('orders').doc('$serviceId-$subCatId-${_dateTime.hour}:${_dateTime.minute}-${_dateTime.day}-${_dateTime.month}-${_dateTime.year}').path;
    String url;
    url = 'http://139.59.4.68/api/v1/order/addOrder';
    await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ' + mappedData['token'],
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic> {
        'user': myId,
        'service_provider': serviceId,
        'service': subCatId,
      }),
    ).then((res) async{
      if(jsonDecode(res.body)['message'].toString().contains('created')) {
        Fluttertoast.showToast(
          msg: 'Please wait. Sending notification.',
        );
        await _firebaseFirestore.doc(path).set({
          'userId': myId,
          'serviceId': serviceId,
          'requestId': jsonDecode(res.body)['data'].toString(),
          'subCatId': subCatId,
          'status': 'requested',
          'userFCMToken': _fcmToken,
          'serviceFCMToken': serviceFCMToken,
        });
        String serviceProviderName;
        for(int i = 0; i < serviceProvidersData.length; i++) {
          if(serviceProvidersData[i]['id'].toString() == serviceId) {
            setState(() {
              serviceProviderName = serviceProvidersData[i]['name'];
            });
          }
        }
        String orderNotificationTitle = 'New Order', orderNotificationBody = 'Order received for the service $searchText from ${mappedData['name']}', orderNotificationMyTitle = 'Order Sent', orderNotificationMyBody = 'Order sent to $serviceProviderName for the service $searchText';
        await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAH13n1BU:APA91bHccnUDikZ9s9ioBEjIQnzGx2hCfkZNil62hFfgKo8rmQ6FJnHm32snXdLc2TKHnldpCN_1Qn1Ie530VpFVJXdN29MyVyMXoT6kQITN9DzaJRYrv1ORjn8cSe2Tv1C45wdGg2z_',
          },
          body: jsonEncode(<String, dynamic> {
            "notification": {
              "title": orderNotificationTitle,
              "body": orderNotificationBody,
            },
            "priority": "high",
            "data": {
              'userName': mappedData['name'],
              'userId': myId,
              'serviceId': serviceId,
              'subCatId': subCatId,
              'userFCMToken': _fcmToken,
              'serviceFCMToken': serviceFCMToken,
              'path': path,
              'goto': 2,
              'requestId': jsonDecode(res.body)['data'].toString(),
            },
            "to": "$serviceFCMToken"
          }),
        ).then((value) {
          if(jsonDecode(value.body)['results'][0]['message_id'] != null) {
            Fluttertoast.showToast(
              msg: 'Request sent successfully',
            );
            awesomeNotifications.createNotification(
              content: NotificationContent(
                id: int.parse(subCatId),
                channelKey: 'hnNotifications',
                title: orderNotificationMyTitle,
                body: orderNotificationMyBody,
                color: Colors.amber,
                payload: {
                  'goto': '2',
                },
              ),
            );
          }
          getMyOrders();
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(
            msg: onError.toString(),
          );
        });
      }
      DefaultTabController.of(_scaffoldKey.currentContext).animateTo(2);
      setState(() {
        showingOrders = true;
        showingToday = true;
      });
      onRefresh();
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
    });
  }

  showConfirmSend(String myId, String serviceId, String subCatId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Text(
            'Confirm Order?',
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
                sendOrder(myId, serviceId, subCatId);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

  showLoadingPopup() {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).accentColor.withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            height: 70,
            width: 70,
            child: ShowLoading(),
          ),
        );
      },
    );
  }

  showAddBillDetailsPopup(String orderId, String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: FinishingOrder(orderId, serviceId),
          ),
          title: Text(
            'Add bill details',
            style: Theme.of(context).textTheme.headline5,
          ),
          titlePadding: EdgeInsets.only(top: 10, left: 10),
        );
      },
      barrierDismissible: false,
    );
  }

  serviceList() {
    if(list9.isEmpty && list15.isEmpty && list25.isEmpty)
      getService();
    if(list9.isNotEmpty && !fetching) {
      return Column(
        children: list9.length >= 5 ? list9.getRange(0, 5).toList() : list9,
      );
    } else if(list15.isNotEmpty && !fetching) {
      return Column(
        children: list15.length >= 5 ? list15.getRange(0, 5).toList() : list15,
      );
    } else if(list25.isNotEmpty && !fetching) {
      return Column(
        children: list25.length >= 5 ? list25.getRange(0, 5).toList() : list25,
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'No service providers available for selected service' + ' - ${txt.text}',
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }
  }

  Future onRefresh() async{
    showLoadingPopup();
    await getService();
    await getMyOrders();
    await getMyDetails();
    await getRequired();
    await getSubCat();
    await _getCurrentLocation();
    await getMain();
    orderId != null ?? getOrderItems(orderId);
    Navigator.pop(context);
  }

  getName(String id) {
    for(int i = 0; i < serviceProvidersData.length; i++) {
      if(serviceProvidersData[i]['id'].toString() == id) {
        return serviceProvidersData[i]['name'];
      }
    }
    return '';
  }

  getDetails(String id) {
    for(int i = 0; i < serviceProvidersData.length; i++) {
      if(serviceProvidersData[i]['id'].toString() == id) {
        return serviceProvidersData[i]['street'] + ',\n' + serviceProvidersData[i]['city'] + ',\n' + serviceProvidersData[i]['state'] + ',\n' + serviceProvidersData[i]['country'] + ' - ' + serviceProvidersData[i]['zip'];
      }
    }
    return '';
  }

  getBillDetails(String id) async{
    showLoadingPopup();
    await http.get(
      'http://139.59.4.68/api/v1/order/getOrderDetails?id=$id',
      headers: <String, String>{
        'Authorization': 'Bearer ' + mappedData['token'],
        'Content-Type': 'application/json',
      },
    ).then((value) {
      if(jsonDecode(value.body).length != null && jsonDecode(value.body).length != 0) {
        String date = jsonDecode(value.body)['created_at'].toString().substring(8, 10), month = jsonDecode(value.body)['created_at'].toString().substring(5, 7), year = jsonDecode(value.body)['created_at'].toString().substring(0, 4), hour = jsonDecode(value.body)['created_at'].toString().substring(11, 13), minute = jsonDecode(value.body)['created_at'].toString().substring(14, 16);
        DateTime timeValue = DateTime.utc(int.parse(year), int.parse(month), int.parse(date), int.parse(hour), int.parse(minute)).toLocal();
        int y = timeValue.year, m = timeValue.month, d = timeValue.day, h = timeValue.hour, min = timeValue.minute;
        String display = '';
        bool isPM = false;
        if(d < 10) {
          display = display + '0$d';
        } else {
          display = display + '$d';
        }
        if(m < 10) {
          display = display + ' - 0$m';
        } else {
          display = display + ' - $m';
        }
        display = display + ' - $y';
        if(h < 10) {
          display = display + ' 0$h';
        } else if(h < 13) {
          display = display + ' $h';
        } else if(h < 24) {
          isPM = true;
          display = display + ' ${h - 12}';
        }
        if(min < 10) {
          display = display + ':0$min';
        } else {
          display = display + ':$min';
        }
        if(isPM) {
          display = display + ' PM';
        } else {
          display = display + ' AM';
        }
        setState(() {
          orderId = jsonDecode(value.body)['id'].toString();
          orderDate = display;
          orderFrom = jsonDecode(value.body)['service_provider'].toString();
          orderTo = jsonDecode(value.body)['user'].toString();
        });
      }
    });
    Navigator.pop(context);
  }

  getOrderItems(String id) async{
    setState(() {
      gettingItems = true;
    });
    await http.get(
      'http://139.59.4.68/api/v1/order/getOrderItem?orders=$id',
      headers: <String, String>{
        'Authorization': 'Bearer ' + mappedData['token'],
        'Content-Type': 'application/json',
      },
    ).then((value) {
      orderItems.clear();
      if(jsonDecode(value.body).length != null && jsonDecode(value.body).length != 0) {
        jsonDecode(value.body).forEach((element) {
          orderItems.add({
            'item': element['name'],
            'charge': element['charge'],
          });
        });
      }
    });
    setState(() {
      gettingItems = false;
    });
  }

  getTable() {
    double totalBill = 0.0;
    List<TableRow> tableRows = [];
    tableRows.clear();
    tableRows.add(TableRow(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Item/Service',
            style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Item/Service Price',
            style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        ),
      ],
    ));
    orderItems.forEach((element) {
      setState(() {
        totalBill = totalBill + double.parse(element['charge']);
      });
      tableRows.add(TableRow(
        children: [
          Container(
          padding: EdgeInsets.all(10),
            child: Text(
              element['item'],
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
          padding: EdgeInsets.all(10),
            child: Text(
              '₹' + element['charge'],
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ));
    });
    tableRows.add(TableRow(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.centerRight,
          child: Text(
            'Total Bill',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            '₹$totalBill',
            style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ));
    return tableRows;
  }

  Future saveAsPDF(String orderId, String date, from, to) async{
    double totalValue = 0;
    final path = '$mainFolderPath/OrderID-$orderId';
    saveFile = File(path);
    PdfDocument document = PdfDocument();
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: PdfStandardFont(
        PdfFontFamily.helvetica,
        16,
      ),
      cellPadding: PdfPaddings(left: 10, right: 10, top: 10, bottom:  10),
    );
    grid.columns.add(
      count: 2,
    );

    PdfGridRow rows1 = grid.rows.add();
    rows1.cells[0].value = 'Order ID: $orderId';
    rows1.cells[1].value = 'Date: $date';

    PdfGridRow rows2 = grid.rows.add();
    rows2.cells[0].value = 'From:\n$from';
    rows2.cells[1].value = 'To:\n$to';

    PdfGridRow rows3 = grid.rows.add();
    rows3.cells[0].value = 'Item/Service';
    rows3.cells[1].value = 'Item/Service Price';

    orderItems.forEach((element) {
      PdfGridRow rows = grid.rows.add();
      rows.cells[0].value = element['item'];
      rows.cells[1].value = element['charge'];
      setState(() {
        totalValue = totalValue + double.parse(element['charge']);
      });
    });

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Total Bill';
    row.cells[1].value = totalValue.toString();

    grid.draw(
      page: document.pages.add(),
      bounds: Rect.fromLTRB(0, 0, 0, 0),
    );

    List<int> bytes = document.save();
    document.dispose();
    saveFile.writeAsBytes(bytes).then((value) {
      OpenFile.open(value.path);
    });
  }
}

class FinishingOrder extends StatefulWidget {

  final orderId;
  final serviceId;

  FinishingOrder(this.orderId, this. serviceId);

  @override
  _FinishingOrderState createState() => _FinishingOrderState(orderId, serviceId);
}

class _FinishingOrderState extends State<FinishingOrder> {

  final orderId;
  final serviceId;

  _FinishingOrderState(this.orderId, this. serviceId);

  List<String> items = [''];
  String bUrl = 'http://139.59.4.68/api/v1/';
  bool success = true, proceed = true;
  int totalCost = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          '${(index + 1).toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Item',
                            hintStyle: Theme.of(context).textTheme.headline5,
                            border: InputBorder.none,
                          ),
                          maxLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            setState(() {
                              items[index] = val;
                            });
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/5,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cost',
                            hintStyle: Theme.of(context).textTheme.headline5,
                            border: InputBorder.none,
                            prefixText: '₹',
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              costs[index] = val;
                            });
                          },
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      items.clear();
                      costs.clear();
                      items.add('');
                      costs.add('');
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor.withOpacity(0.8),
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
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if(items.last != '' && costs.last != '') {
                      setState(() {
                        items.add('');
                        costs.add('');
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Fill all the fields in last one before adding a new one',
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
                      'Add Item',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async{
                    for(int i = 0; i < items.length; i++) {
                      for(int j = i + 1; j < items.length; j++) {
                        if(items[i] == items[j]) {
                          proceed = false;
                        }
                      }
                    }
                    if(proceed) {
                      showLoadingPopup();
                      await addItems();
                      await finishOrder(orderId, serviceId);
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Items cannot be repeated',
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Text(
                      'Finish order',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future addItems() async{
    String url;
    setState(() {
      url = bUrl + 'order/addOrderItem';
    });
    costs.forEach((element) {
      totalCost = totalCost + int.parse(element);
      print(totalCost);
    });
    items.forEach((element) async{
      await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ' + mappedData['token'],
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic> {
          'orders': int.parse(orderId),
          'charge': int.parse(costs[items.indexOf(element)]),
          'name': element,
        }),
      ).then((value) {
        if(jsonDecode(value.body)['message'] != 'Item created.') {
          setState(() {
            success = false;
          });
        }
      });
    });
  }

  finishOrder(String orderId, String serviceId) async{
    String url;
    setState(() {
      url = bUrl + 'order/updateOrder';
    });
    if(success) {
      await _firebaseFirestore.collection('users').doc(serviceId).get().then((value) {
        serviceFCMToken = value.data()['fcmToken'];
      });
      await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ' + mappedData['token'],
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic> {
          'id': orderId,
          'status': 'completed',
        }),
      ).then((value) async{
        if(jsonDecode(value.body)['message'].toString().contains('updated')) {
          await http.post(
            'https://fcm.googleapis.com/fcm/send',
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=AAAAH13n1BU:APA91bHccnUDikZ9s9ioBEjIQnzGx2hCfkZNil62hFfgKo8rmQ6FJnHm32snXdLc2TKHnldpCN_1Qn1Ie530VpFVJXdN29MyVyMXoT6kQITN9DzaJRYrv1ORjn8cSe2Tv1C45wdGg2z_',
            },
            body: jsonEncode(<String, dynamic> {
              "notification": {
                "title": "Order completed",
                "body": "Order completed successful. Your bill is $totalCost for the order ID: $orderId",
              },
              "priority": "high",
              "data": {

              },
              "to": "$serviceFCMToken"
            }),
          ).then((value) {
            if(jsonDecode(value.body)['results'][0]['message_id'] != null) {
              Fluttertoast.showToast(
                msg: 'Order completed successfully',
              );
            }
          }).catchError((onError) {
            Fluttertoast.showToast(
              msg: onError.toString(),
            );
          });
          setState(() {
            finished = true;
          });
          Navigator.pop(context);
        }
      }).catchError((onError) {
        Fluttertoast.showToast(
          msg: onError.toString(),
        );
      });
    } else {
      await http.get(
        'http://139.59.4.68/api/v1/order/getOrderItem?orders=$orderId',
        headers: <String, String>{
          'Authorization': 'Bearer ' + mappedData['token'],
          'Content-Type': 'application/json',
        },
      ).then((value) async{
        if(jsonDecode(value.body).length != null && jsonDecode(value.body).length != 0) {
          jsonDecode(value.body).forEach((element) async{
            await http.get(
              'http://139.59.4.68/api/v1/order/deleteItem?id=${element['id']}',
              headers: <String, String>{
                'Authorization': 'Bearer ' + mappedData['token'],
                'Content-Type': 'application/json',
              },
            );
          });
        }
      });
      Fluttertoast.showToast(
        msg: 'Error. Try again',
      );
    }
  }

  showLoadingPopup() {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).accentColor.withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            height: 70,
            width: 70,
            child: ShowLoading(),
          ),
        );
      },
    );
  }
}
