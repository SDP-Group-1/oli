/**
 * background.dart - contains the stateless widget that provides the
 * UI for fall detection. There are a lot of background processes going
 * on here, with respect to listening to sensors and inserting data
 * into the SQLite database (see database.dart for helper methods).
 */
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:oli/database.dart';
import 'package:oli/flaskApi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors/sensors.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import 'postFall.dart';

import 'flaskApi.dart';

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
  int currentID;
  int triggerID;
  bool isTriggered = false;
  DatabaseHelper helper;
  Timer sensorReadings;

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    // final List<String> userAccelerometer = _userAccelerometerValues
    //     ?.map((double v) => v.toStringAsFixed(1))
    //     ?.toList();
    return new Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Accelerometer: $accelerometer',
                    style: TextStyle(fontSize: 20)),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Triggered: $isTriggered', style: TextStyle(fontSize: 20)),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gyroscope: $gyroscope', style: TextStyle(fontSize: 20)),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
          )
        ]));
  }

  @override
  //current error here - why is the below print statement not being registered
  //in the log when the app closes?
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
      print('cancelling stream subscriptions');
    }
    helper.dropTable();
  }

  @override
  void initState() {
    super.initState();
    currentID = 0;
    triggerID = 0;
    helper = DatabaseHelper.instance;

    sensorReadings = new Timer.periodic(Duration(milliseconds: 20), (Timer x) {
      updateDatabase();
    });

//monitoring sensors
    new MethodChannel("flutter.temp.channel")
        .setMethodCallHandler(platformCallHandler);
    _userAccelerometerValues = <double>[0.0, 0.0, 0.0];
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
  }

  void callClassifier() async {
    sensorReadings.cancel();
    String dataset = await writeCSV(triggerID - 100, triggerID + 150);
    print(dataset);
    print("Finished writing sensor data in CSV, sending to classifier");
    var classifierResult = await getPredict(dataset);
    print("Classifier result : $classifierResult");
    if (classifierResult == 'Fall') {
      setState(() {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Fall(hasFallen: true),
          ),
        );
      });
    } else {
      setState(() {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Fall(hasFallen: false),
          ),
        );
      });
    }
  }

  /////
  Future<int> updateDatabase() async {
    print('logging sensor data into database');
    Reading reading = Reading();
    reading.accelerometerX = _accelerometerValues[0];
    reading.accelerometer_y = _accelerometerValues[1];
    reading.accelerometer_z = _accelerometerValues[2];
    reading.gyro_x = _gyroscopeValues[0];
    reading.gyro_y = _gyroscopeValues[1];
    reading.gyro_z = _gyroscopeValues[2];
    currentID = await helper.insert(reading);

    //checking if reading has crossed threshold here
    if (sqrt(pow(reading.accelerometerX, 2) +
                pow(reading.accelerometer_y, 2) +
                pow(reading.accelerometer_z, 2)) >
            17 &&
        triggerID == 0) {
      triggerID = currentID;
      isTriggered = true;
      print(
          '--------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx------------------');
      print("Classifier triggered");
      Future.delayed(Duration(seconds: 3), () {
        print(triggerID.toString() + ': trigger ID');
        callClassifier();
      });
    }
    print(currentID.toString() + ":currentID _________________________");
  }

  Future<String> writeCSV(int id1, int id2) async {
    print("============================================");
    print("$id1 to $id2");
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
      print('cancelling subs');
    }
    // final directory = await getApplicationDocumentsDirectory();
    // print(directory);
    // final file = File('${directory.path}/dataset.csv');
    // print('file created');
    var requiredWindow = await helper.queryReadings(id1, id2);
    print('query done');
    var dataset = mapListToCsv(requiredWindow);
    return dataset;
  }

  Future<dynamic> platformCallHandler(MethodCall call) async {
    if (call.method == "destroy") {
      print("destroy");
      dispose();
    }
  }
} //_BACKGROUND ACTIVITY STATE
