import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Call extends StatefulWidget {
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  Location location = Location();
  LocationData _locationData;
  String lat;
  String lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lat = _locationData.latitude.toString();
    lng = _locationData.longitude.toString();
    return FutureBuilder(
        future: getLoc(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Calling OLI'),
              ),
              body: Center(
                child: Text(
                    "Please wait while OLI moves towards you. Location: $lng, $lat"),
              ),
            );
          } else if (snapshot.hasError) {
            throw snapshot.error;
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // this data can then be parsed into something that can be sent through
    // bluetooth for OLI to read
    _locationData = await location.getLocation();
    developer.log(_locationData.longitude.toString());
  }
}
