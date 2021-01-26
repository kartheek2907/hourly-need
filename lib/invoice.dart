import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class Invoice extends StatefulWidget {
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
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
        title: Text(
          'Invoice/Quotation',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/2 - 10,
                      minWidth: MediaQuery.of(context).size.width/2 - 10,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order No:\t\t',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Or000901'.toUpperCase(),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/2 - 10,
                      minWidth: MediaQuery.of(context).size.width/2 - 10,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date:\t\t',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '21/01/2021'.toUpperCase(),
                          style: Theme.of(context).textTheme.headline5,
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
                      maxWidth: MediaQuery.of(context).size.width/2 - 10,
                      minWidth: MediaQuery.of(context).size.width/2 - 10,
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
                          'Home care pvt ltd,\nLicense No: PR67890,\nDOOR-N0-43,\nVA-300045,\nUSA',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/2 - 10,
                      minWidth: MediaQuery.of(context).size.width/2 - 10,
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
                          'Kathy More,\nDoor No: 78\nVA-300045\nUSA',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Table(
                border: TableBorder.all(
                  color: Color(0xFFDCDCDC),
                  width: 1,
                  style: BorderStyle.solid,
                ),
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/3,
                          maxWidth: MediaQuery.of(context).size.width/3,
                        ),
                        child: Text(
                          'Item/Work',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/5,
                          maxWidth: MediaQuery.of(context).size.width/5,
                        ),
                        child: Text(
                          'Quantity',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/5,
                          maxWidth: MediaQuery.of(context).size.width/5,
                        ),
                        child: Text(
                          'Unit Price',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/4.8,
                          maxWidth: MediaQuery.of(context).size.width/4.8,
                        ),
                        child: Text(
                          'Item/Work Price',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/3,
                          maxWidth: MediaQuery.of(context).size.width/3,
                        ),
                        child: Text(
                          'Water leakage fixed',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/5,
                          maxWidth: MediaQuery.of(context).size.width/5,
                        ),
                        child: Text(
                          '2',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/5,
                          maxWidth: MediaQuery.of(context).size.width/5,
                        ),
                        child: Text(
                          '₹150',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/4.8,
                          maxWidth: MediaQuery.of(context).size.width/4.8,
                        ),
                        child: Text(
                          '₹300',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/3,
                          maxWidth: MediaQuery.of(context).size.width/3,
                        ),
                        child: Text(
                          'Taps',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/5,
                          maxWidth: MediaQuery.of(context).size.width/5,
                        ),
                        child: Text(
                          '2',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/5,
                          maxWidth: MediaQuery.of(context).size.width/5,
                        ),
                        child: Text(
                          '₹100',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/4.8,
                          maxWidth: MediaQuery.of(context).size.width/4.8,
                        ),
                        child: Text(
                          '₹200',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(),
                      Container(),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width*5,
                          maxWidth: MediaQuery.of(context).size.width*5,
                        ),
                        child: Center(
                          child: Text(
                            'Total Bill:',
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width/4.8,
                          maxWidth: MediaQuery.of(context).size.width/4.8,
                        ),
                        child: Text(
                          '₹500',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 0, top: 15),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        'Approve',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}