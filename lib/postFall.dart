import 'package:loading_gifs/loading_gifs.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// class FallDetection extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Scaffold(body: Fall());
//   }
// }

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
  final bool hasFallen;

  const Fall({Key key, this.hasFallen}) : super(key: key);
  @override
  _FallState createState() => _FallState();
}

class _FallState extends State<Fall> {
  var _isLoading;
  var _counter;
  Timer t;
  Timer a;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _counter = 30;
    new Timer.periodic(Duration(seconds: 2), (t) {
      if (!mounted) return;
      setState(() {
        print('Post-classifier events');
        _isLoading = false;
        t.cancel();
        new Timer.periodic(Duration(seconds: 1), (a) {
          if (!mounted) return;
          setState(() {
            _counter = _counter - 1;
            if (_counter == 0) {
              a.cancel();
              if (widget.hasFallen) {
                Navigator.pushReplacementNamed(context, '/ems');
              }
            }
          });
        });
      });
    });
  }

  @override
  dispose() {
    if (t != null) {
      t.cancel();
    }
    if (a != null) {
      a.cancel();
    }

    super.dispose();
  }

  Widget build(BuildContext context) {
    if (_isLoading) {
      // print('we in here');
      return Scaffold(
          body: Center(
              child: FadeInImage.assetNetwork(
                  placeholder: cupertinoActivityIndicator,
                  image: 'assets_logo2.png')));

      // Text('LOADING',
      //     style: TextStyle(
      //         fontWeight: FontWeight.w900,
      //         color: Color(0xffDB5461),
      //         fontSize: 30))
    } else {
      if (widget.hasFallen) {
        return Scaffold(
            body: Center(
                child: Column(children: [
          Text('A fall has been detected.',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xffDB5461),
                  fontSize: 32)),
          Text('Calling emergency services in $_counter seconds',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xff2B3964),
                  fontSize: 20)),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Text('I\'m fine! Stop the call!',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xffDB5461),
                    fontSize: 25)),
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
