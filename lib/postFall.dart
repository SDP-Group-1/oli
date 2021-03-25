import 'package:loading_gifs/loading_gifs.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FallDetection extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: Fall());
  }
}

class EMS extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text(
                'Calling emergency services. \nOLI is navigating towards you.',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20))));
  }
}

class Fall extends StatefulWidget {
  @override
  _FallState createState() => _FallState();
}

class _FallState extends State<Fall> {
  var _isLoading;
  var _hasFallen;
  var _counter;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasFallen = true;
    _counter = 10;
    new Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        print('yoyoyoyoyo');
        _isLoading = false;
        t.cancel();
        new Timer.periodic(Duration(seconds: 1), (Timer a) {
          setState(() {
            _counter = _counter - 1;
            if (_counter == 0) {
              a.cancel();
              Navigator.pushReplacementNamed(context, '/ems');
            }
          });
        });
      });
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (_isLoading) {
      // print('we in here');
      return Scaffold(
          body: Center(
              child: FadeInImage.assetNetwork(
                  placeholder: cupertinoActivityIndicator,
                  image: "image.png")));

      // Text('LOADING',
      //     style: TextStyle(
      //         fontWeight: FontWeight.w900,
      //         color: Color(0xffDB5461),
      //         fontSize: 30))
    } else {
      if (_hasFallen) {
        return Scaffold(
            body: Center(
                child: Column(children: [
          Text('Yes, you fell',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xffDB5461),
                  fontSize: 30)),
          Text('Calling emergency services in $_counter seconds',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xffDB5461),
                  fontSize: 15)),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Text('I\'m fine! Stop the call!',
                style: TextStyle(
                    fontWeight: FontWeight.w900, color: Color(0xffDB5461))),
          )
        ], mainAxisSize: MainAxisSize.min)));
      } else {
        return Scaffold(
            body: Center(
                child: Text('Hey! False alarm!',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 30))));
      }
    }
  }
}
