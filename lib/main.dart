import 'package:flutter/material.dart';
import 'home.dart';

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
