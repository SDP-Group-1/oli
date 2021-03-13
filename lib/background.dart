import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:oli/database.dart';
import 'package:sensors/sensors.dart';

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
    var a = helper.dropTable();
    //should probably replace the a with something else :/
  }

  @override
  void initState() {
    super.initState();
    helper = DatabaseHelper.instance;
    //referencing database.dart

    //tried to create table again using the method every time initstate is called
    //but error here - table not found
    // helper.onCreate(helper.getDatabase(), helper.getDatabaseVersion());
    new MethodChannel("flutter.temp.channel")
        .setMethodCallHandler(platformCallHandler);
    _userAccelerometerValues = <double>[0.0, 0.0, 0.0];
    const fiveSecondInterval = const Duration(seconds: 5);
    new Timer.periodic(fiveSecondInterval, (Timer t) {
      updateDatabase(); //write csv file here, delete contents of db / create new db????
    });
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        //if 15 m/s^2 is crossed
        _accelerometerValues = <double>[event.x, event.y, event.z];
        if (sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)) > 15) {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
        }
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    // _streamSubscriptions
    //     .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    //   setState(() {
    //
    //   });
    // }));
  }

  /////
  void updateDatabase() async {
    print('This timer works');
    Reading reading = Reading();
    reading.accelerometerX = _userAccelerometerValues[0];
    reading.accelerometer_y = _userAccelerometerValues[1];
    reading.accelerometer_z = _userAccelerometerValues[2];
    reading.gyro_x = _gyroscopeValues[0];
    reading.gyro_y = _gyroscopeValues[1];
    reading.gyro_z = _gyroscopeValues[2];
    int id = await helper.insert(reading);
    print(id);
    Reading x = await helper.queryReading(id);
    print("frm table ");
    print(x.accelerometerX);
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
