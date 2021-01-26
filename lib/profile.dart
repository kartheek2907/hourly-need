import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    initialValue: 'Kathy More',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                Container(
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
                    initialValue: 'kathymore@gmail.com',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
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
                    initialValue: '+91 9876543210',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'H - No',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                    ),
                    initialValue: 'Door No - 1',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Street',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                    ),
                    initialValue: 'Street No - 1',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'City',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                    ),
                    initialValue: 'Ranchi',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'State',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                    ),
                    initialValue: 'Jharkand',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Country',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                    ),
                    initialValue: 'India',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'ZIP Code',
                      labelStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  isDense: true,
                    ),
                    initialValue: '999999',
                    style: Theme.of(context).textTheme.headline5,
                    keyboardType: TextInputType.number,
                  ),
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
}