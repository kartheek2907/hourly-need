import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showDate = false;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(
              showDate ? Icons.close : Icons.today_sharp,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.only(top: 0, bottom: 20, left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Orders',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'List of your orders',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            if(selectedDate.day == DateTime.now().day && selectedDate.month == DateTime.now().month && selectedDate.year == 2021) Container(
              margin: EdgeInsets.only(left: 9, right: 9, top: 20),
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
                ]
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
                                  '${DateTime.now().day}-${DateTime.now().month}-2021, 3:15 pm',
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'OR000901',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Home Care PVT LTD',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹500.00',
                              style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Payment via cash',
                              style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'View',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download_sharp,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'PDF',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if(selectedDate.day == 27 && selectedDate.month == 12 && selectedDate.year == 2020) Container(
              margin: EdgeInsets.only(left: 9, right: 9, top: 20),
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
                  ]
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
                                  '27-12-2020, 6:15 pm',
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'OR000901',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Home Care PVT LTD',
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹500.00',
                              style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Payment via cash',
                              style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'View',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download_sharp,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'PDF',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
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
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}