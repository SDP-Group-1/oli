import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:isolate';

class BackgroundSensors extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sensor screen")),
    );
  }
}

class BackgroundActivity extends StatefulWidget {
  @override
  _BackgroundActivityState createState() => _BackgroundActivityState();
}

class _BackgroundActivityState extends State<BackgroundActivity> {
  Isolate _isolate;
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Sensing movement'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Something here'),
            ],
          ),
        ));
  }
}
