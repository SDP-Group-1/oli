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
  String lat;
  String lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationData>(
        future: getLoc(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            lat = snapshot.data.latitude.toString();
            lng = snapshot.data.longitude.toString();
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

  Future<LocationData> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // this data can then be parsed into something that can be sent through
    // bluetooth for OLI to read
    LocationData _locationData = await location.getLocation();

    return _locationData;
  }
}
