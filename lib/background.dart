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
  DatabaseHelper helper;

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();
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
                Text('Acc that crossed threshold: $userAccelerometer',
                    style: TextStyle(fontSize: 20)),
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
      print('cancelling subs');
    }
    helper.dropTable();
    //should probably replace the a with something else :/
  }

  @override
  void initState() {
    super.initState();
    currentID = 0;
    triggerID = 0;
    helper = DatabaseHelper.instance;
    //referencing database.dart

    //tried to create table again using the method every time initstate is called
    //but error here - table not found
    // helper.onCreate(helper.getDatabase(), helper.getDatabaseVersion());
    new MethodChannel("flutter.temp.channel")
        .setMethodCallHandler(platformCallHandler);
    _userAccelerometerValues = <double>[0.0, 0.0, 0.0];
    const twoSeconds = const Duration(seconds: 2);
    // new Timer.periodic(fiveSecondInterval, (Timer t) {
    //   //write csv file here, delete contents of db / create new db????
    // });
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        //if 17 m/s^2 is crossed
        updateDatabase();
        _accelerometerValues = <double>[event.x, event.y, event.z];
        if (sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)) > 17 &&
            triggerID == 0) {
          triggerID = currentID;
          print(
              'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx------------------');
          print("We been triggered");
          Future.delayed(twoSeconds, () {
            print(triggerID.toString() + ': trigger ID');

            // String directory_path =
            //'/data/user/0/com.example.oli/app_flutter/dataset.csv';
            callClassifier();
          });
        }
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  void callClassifier() async {
    String directoryPath = await writeCSV(triggerID - 20, triggerID + 20);
    print("something here to see if it works");
    print(directoryPath);
    print("Finished writing CSV, now classifier");
    var classifierResult = await getPredict(directoryPath);
    if (classifierResult == 1) {
      setState(() {
        Navigator.popAndPushNamed(context, '/fall');
      });
    } else {
      print("Not a fall");
    }
  }

  /////
  Future<int> updateDatabase() async {
    print('This timer works');
    Reading reading = Reading();
    reading.accelerometerX = _accelerometerValues[0];
    reading.accelerometer_y = _accelerometerValues[1];
    reading.accelerometer_z = _accelerometerValues[2];
    reading.gyro_x = _gyroscopeValues[0];
    reading.gyro_y = _gyroscopeValues[1];
    reading.gyro_z = _gyroscopeValues[2];
    currentID = await helper.insert(reading);
    print(currentID.toString() + ":currentID _________________________");
  }

  Future<String> writeCSV(int id1, int id2) async {
    print("=====================================");
    print("$id1 to $id2");
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
      print('cancelling subs');
    }
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    final file = File('${directory.path}/dataset.csv');
    print('file created');
    var requiredWindow = await helper.queryReadings(id1, id2);
    print('query done');
    var dataset = mapListToCsv(requiredWindow);
    print(dataset);
    file.writeAsString(dataset);
    print("File path");
    print(file.path);
    return file.path;
    //optional - add Navigator,pop to remove this from the route
    //will automatically call dispose - then add the new widget depending on
    //whether that was a fall or not.
  }

  Future<dynamic> platformCallHandler(MethodCall call) async {
    if (call.method == "destroy") {
      print("destroy");
      dispose();
    }
  }
} //_BACKGROUND ACTIVITY STATE

////TO DEBUG -
///Why database never closes / deletes?
/// Values not getting inserted into db but condition (accelerometer) being read correctly
///
