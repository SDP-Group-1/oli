import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';

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
            sendSignal();
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



  // to be updated in the future
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

  sendSignal() async{
    FTPConnect ftpConnect = FTPConnect('example.com', user:'oli', pass:'oli');
    File signal = File('OLI-COMMAND');
    signal.openWrite();
    await signal.writeAsString("CALL, $lng, $lat");
    await ftpConnect.connect();
    bool res = await ftpConnect.uploadFileWithRetry(signal, pRetryCount: 2);
    await ftpConnect.disconnect();
  }
}
