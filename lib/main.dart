import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OLI',
      theme: ThemeData(
          primaryColor: Color(0xffFFEFEB),
          fontFamily: 'Yaldevi Colombo',
          scaffoldBackgroundColor: Color(0xffFFEFEB),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(primary: Color(0xff2B3964)))),
      home: HomePage(),
    );
  }
}

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
                HomeButtons()
              ],
            )
            //   appBar: AppBar(
            //       title: Text('OLI',
            //           style: TextStyle(
            //               fontWeight: FontWeight.w700, color: Color(0xff2B3964))),
            //       backgroundColor: Color.fromRGBO(255, 239, 235, 1),
            //       centerTitle: true,
            //       shadowColor: Color.fromRGBO(0, 0, 0, 0),
            //       toolbarHeight: 100),
            //   body: HomeButtons(),
            ));
  }
}

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 0, top: 40.0, right: 0, bottom: 0),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Call OLI',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xffDB5461))),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Setup',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xffDB5461))),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Fall Sensor Demo',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xffDB5461))),
            ),
          ],
        )));
  }
}
