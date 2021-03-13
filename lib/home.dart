import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
                              color: Color(0xffDB5461))),
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
                      child: Text('Setup',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xffDB5461))),
                    ))),
            Padding(
                //BACKGROUND SENSOR DEMO BUTTON
                padding: EdgeInsets.only(top: 10.0),
                child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/background');
                      },
                      child: Text('Background sensors demo',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xffDB5461))),
                    ))),
          ],
        )));
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
    if (isConnected) return Padding(
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
          fontWeight: FontWeight.w900,
          color: Color(0xffDB5461))
        ),
        ],
        ),
      ),
    );
    else return Padding(
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
                    fontWeight: FontWeight.w900,
                    color: Color(0xffDB5461))
            ),
          ],
        ),
      ),
    );
  }
}
