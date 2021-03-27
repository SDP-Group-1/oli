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

class ThankYou extends StatelessWidget {
  ThankYou(this.username);
  final String username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Submitted'),
        ),
        body: Center(
            child: RichText(
                text: new TextSpan(
                    style: new TextStyle(
                        fontSize: 30,
                        fontFamily: 'Yaldevi Colombo',
                        color: Color(0xff2B3964)),
                    children: <TextSpan>[
              new TextSpan(
                  text: 'Nice to meet you ',
                  style: new TextStyle(fontWeight: FontWeight.w300)),
              new TextSpan(
                text: '$username!',
                style: new TextStyle(fontWeight: FontWeight.bold),
              )
            ]))));
  }
}

class DetailForm extends StatefulWidget {
  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  String username;
  String contactNumber;
  String postcode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 300,
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      onSaved: (String value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Enter your name',
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        onSaved: (String value) {
                          contactNumber = value;
                        },
                        decoration: InputDecoration(
                            icon: Icon(Icons.phone),
                            hintText: 'Input emergency contact number',
                            labelText: 'Emergency contact',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20)),
                        validator: (value) {
                          if (value.isEmpty || value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        }),
                    TextFormField(
                      onSaved: (String value) {
                        postcode = value;
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.home_filled),
                          hintText: '6 digit postcode without spaces',
                          labelText: 'Enter your postcode',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)),
                      validator: (value) {
                        if (value.isEmpty ||
                            value.length < 6 ||
                            value.length > 6) {
                          return "Please enter a valid UK postcode";
                        }
                        return null;
                      },
                    ),
                    Center(
                        child: Container(
                            child: ElevatedButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/'));
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (_) =>
                                                new ThankYou(username)));
                                  }
                                })))
                  ],
                ))));
  }
}
