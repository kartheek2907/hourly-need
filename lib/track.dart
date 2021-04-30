import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class Track extends StatefulWidget {
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {

  Position curLoc;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  String trackingId;
  double dist, time;
  List<LatLng> polyPoints = [];
  File file;
  Map<String, dynamic> mappedData, serviceData, polyData;
  bool isLoading = true;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  _getCurrentLocation() async{
    setState(() {
      isLoading = true;
    });
    final extDir = await getExternalStorageDirectory();
    String path = '${extDir.path}/details.json';
    file = File(path);
    String data = await file.readAsString();
    mappedData = jsonDecode(data);
    setState(() {
      trackingId = mappedData['trackingId'].toString();
    });
    await http.get(
      'http://139.59.4.68/api/v1/service/searchServiceProvider?id=$trackingId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + mappedData['token'],
      },
    ).then((value) {
      setState(() {
        serviceData = jsonDecode(value.body)[0];
      });
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        curLoc = position;
      });
      markers.clear();
      if(mappedData['iAm'] != 'user')
      markers.add(
        Marker(
          markerId: MarkerId('src'),
          position: LatLng(curLoc.latitude, curLoc.longitude),
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId('dest'),
          position: LatLng(double.parse(serviceData['lat']), double.parse(serviceData['lng'])),
        ),
      );
      setPolylines();
    }).catchError((e) {
      print(e);
    });
  }

  setPolylines() async{
    String url = 'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62487d5b7d005e5a47b4b7da1eb66c1ed0c6&start=${curLoc.longitude},${curLoc.latitude}&end=${serviceData['lng']},${serviceData['lat']}';
    await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
      },
    ).then((value) {
      setState(() {
        polyData = jsonDecode(value.body);
      });
      LineString ls = LineString(polyData['features'][0]['geometry']['coordinates']);
      polyPoints.clear();
      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }
      if(polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
      setState(() {
        dist = polyData['features'][0]['properties']['summary']['distance'];
        time = polyData['features'][0]['properties']['summary']['duration'];
      });
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
    });
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    polylines.add(polyline);
    setState(() {
      polylines = polylines;
      isLoading = false;
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading)
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        ),
      );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.4),
        elevation: 0,
        title: Text(
          'Tracking - ${serviceData['name']}',
          style: Theme.of(context).textTheme.headline5.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
      extendBodyBehindAppBar: false,
      body: curLoc != null ? mappedData['iAm'] != 'user' ? GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: markers.first.position,
          zoom: 15.0,
        ),
        markers: markers,
        mapType: MapType.normal,
        polylines: polylines,
      ) : GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: markers.first.position,
          zoom: 15.0,
        ),
        markers: markers,
        mapType: MapType.normal,
      ) : Container(
        child: Text(
          'Error fetching location. Please try again.',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: curLoc != null ? FloatingActionButton.extended(
        onPressed: () {
          if(getText() != 'Reached') {
            Fluttertoast.showToast(
              msg: 'Refreshing',
            );
            _getCurrentLocation();
          }
        },
        icon: Icon(
          (dist != null && time != null) ? Icons.timer_rounded : Icons.done_rounded,
        ),
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          getText(),
          style: Theme.of(context).textTheme.headline6.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ) : FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'track');
        },
        icon: Icon(
          Icons.refresh_rounded,
        ),
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          'Refresh',
          style: Theme.of(context).textTheme.headline6.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  getText() {
    if(time == null || time < 20.0)
      return 'Reached';
    return '${(dist/1000).toStringAsPrecision(3)} KM - ${Duration(seconds: time.ceil()).inMinutes} Min (Tap to refresh)';
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}