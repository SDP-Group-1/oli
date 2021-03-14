import 'package:flutter/material.dart';
import 'auth.dart';

class Setup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    //MAP BUTTON
                    padding: EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Map',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xffDB5461))),
                        ))),
                Padding(
                    //UPDATE DETAILS BUTTON
                    padding: EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text('Update Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xffDB5461))),
                        ))),
              ]),
            )));
  }
}
