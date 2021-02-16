import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OLI',
      theme:
          ThemeData(primaryColor: Colors.blue, fontFamily: 'Yaldevi Colombo'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OLI', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: HomeButtons(),
    );
  }
}

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {},
          child:
              Text('Call OLI', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: Text('Setup', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: Text('Fall Sensor Demo',
              style: TextStyle(fontWeight: FontWeight.w900)),
        ),
      ],
    ));
  }
}
