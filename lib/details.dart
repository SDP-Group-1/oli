import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Your details';
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: DetailForm(),
    );
    // );
  }
}

class DetailForm extends StatefulWidget {
  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'Enter your name',
            labelText: 'Name',
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.phone),
            hintText: 'Input emergency contact number',
            labelText: 'Emergency contact',
          ),
        ),
        TextFormField(
            decoration: InputDecoration(
          icon: Icon(Icons.home_filled),
          hintText: '6 digit postcode',
          labelText: 'Enter your postcode',
        )),
        Center(
            child: Container(
                child: RaisedButton(child: Text('Submit'), onPressed: null)))
      ],
    )));
  }
}
