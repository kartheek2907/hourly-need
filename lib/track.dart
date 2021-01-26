import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Track extends StatefulWidget {
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {

  Position curLoc;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        curLoc = position;
      });
      print(curLoc);
      markers.add(
        Marker(
          markerId: MarkerId('src'),
          position: LatLng(curLoc.latitude, curLoc.longitude),
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId('dest'),
          position: LatLng(curLoc.latitude + 0.001, curLoc.longitude + 0.001),
        ),
      );
      setPolylines();
    }).catchError((e) {
      print(e);
    });
  }

  setPolylines() async{
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      'AIzaSyDums2xri1Mdw3Cxm2c3MdDjsZh3928qJs',
      PointLatLng(curLoc.latitude, curLoc.longitude),
      PointLatLng(curLoc.latitude, curLoc.longitude),
    );

    print(result.points);
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
      body: curLoc != null ? GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(curLoc.latitude, curLoc.longitude),
          zoom: 15.0,
        ),
        markers: markers,
        mapType: MapType.normal,
      ) : Container(),
    );
  }
}
