import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TodaysOrders extends StatefulWidget {
  @override
  _TodaysOrdersState createState() => _TodaysOrdersState();
}

class _TodaysOrdersState extends State<TodaysOrders> {
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
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.only(top: 0, bottom: 20, left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Orders',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'List of ongoing orders',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  '3:15 pm',
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
                            color: Colors.green,
                          ),
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Track',
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
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.limeAccent,
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
      ),
    );
  }
}
