import 'package:flutter/material.dart';
import 'package:oli/setup.dart';
import 'call.dart';
import 'home.dart';
import 'background.dart';
import 'postFall.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //routes: defines navigation pathways on button clicks
      //check home.dart
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/background': (context) => BackgroundSensors(),
        '/call': (context) => Call(),
        '/setup': (context) => Setup(),
        '/hasFallen': (context) => PostFallTrue(),
        '/hasNotFallen': (context) => PostFallFalse()
      },
      title: 'OLI',
      theme: ThemeData(
          primaryColor: Color(0xff2B3964),
          fontFamily: 'Yaldevi Colombo',
          scaffoldBackgroundColor: Color(0xffFFEFEB),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(primary: Color(0xff2B3964)))),
    );
  }
}
