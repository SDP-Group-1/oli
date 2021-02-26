import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:isolate';

class BackgroundSensors extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sensor screen")),
        body: BackgroundActivity());
  }
}

class BackgroundActivity extends StatefulWidget {
  @override
  _BackgroundActivityState createState() => _BackgroundActivityState();
}

class _BackgroundActivityState extends State<BackgroundActivity> {
  //each list element can be linked to one sensor? instead of using
  //broadcast stream
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<double> _accelerometerValues, _gyroscopeValues, _userAccelerometerValues;
  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    return new Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Accelerometer: $accelerometer',
                    style: TextStyle(fontSize: 32)),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
          )
        ]));
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }
} //_BACKGROUND ACTIVITY STATE
