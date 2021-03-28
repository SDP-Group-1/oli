import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(left: 0, top: 100.0, right: 0, bottom: 0),
            child: new Column(
              children: [
                new Text('O.L.I.',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2B3964),
                        fontSize: 100)),
                new Text('operational lifting intern',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2B3964),
                        fontSize: 30)),
                HomeButtons(),
                User(),
                Robot(),
              ],
            )));
  }
}

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                //CALL OLI BUTTON
                padding: EdgeInsets.only(top: 10.0),
                child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/call');
                      },
                      child: Text('Call OLI',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xffdb5461),
                              fontSize: 25)),
                    ))),
            Padding(
                //SET UP BUTTON
                padding: EdgeInsets.only(top: 10.0),
                child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/setup');
                      },
                      child: Text('Set Up',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xffDB5461),
                              fontSize: 25)),
                    ))),
            Padding(
                //BACKGROUND SENSOR DEMO BUTTON
                padding: EdgeInsets.only(top: 10.0),
                child: SizedBox(
                    width: 200,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/background');
                      },
                      child: Align(
                          alignment: Alignment.center,
                          child: Text('Fall detection demo',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xffDB5461),
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.center)),
                    ))),
          ],
        )));
  }
}

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  String userName;

  @override
  void initState() {
    super.initState();
    userName = 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hello, $userName',
                style: TextStyle(
                    fontWeight: FontWeight.w900, color: Color(0xffDB5461))),
          ],
        ),
      ),
    );
  }

  read(String name, String number, String postcode) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/saved_data.txt');
    var lines = await file.readAsLines();
    var splits = lines.last.split(',');
    userName = splits.first;
  }
}

class Robot extends StatefulWidget {
  @override
  _RobotState createState() => _RobotState();
}

class _RobotState extends State<Robot> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    if (isConnected)
      return Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.done_outline,
                color: Colors.green,
              ),
              Text('Robot connected.',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xffDB5461))),
            ],
          ),
        ),
      );
    else
      return Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.clear,
                color: Colors.red,
              ),
              Text('Robot not connected.',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xffDB5461))),
            ],
          ),
        ),
      );
  }

  checkConnection() async {
    // TODO: find out how to properly do this
    FTPConnect ftpConnect = FTPConnect('example.com', user: 'oli', pass: 'oli');
    String fileName = 'OLI-CONNECT';
    File signal = File(fileName);
    await ftpConnect.connect();
    await ftpConnect.downloadFileWithRetry(fileName, signal);
    await ftpConnect.disconnect();

    List<String> lines = await signal.readAsLines();
    var last = DateTime.parse(lines.last);
    if (last.difference(DateTime.now()).inMinutes < 10)
      isConnected = true;
    else
      isConnected = false;
  }
}
