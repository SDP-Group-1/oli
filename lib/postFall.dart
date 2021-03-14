/**
 * postFall.dart - contains two stateless widgets that represents the 
 * two scenarios returned by the classifier - if the sensor readings
 * corresponds to a fall or not.
 */

import 'package:flutter/material.dart';

class PostFallTrue extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Yes, you fell')));
  }
}

class PostFallFalse extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('False alarm')));
  }
}
