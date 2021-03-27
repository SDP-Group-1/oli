import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'dart:io';

class Setup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    sendSignal();
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Padding(
                  //MAP BUTTON
                  padding: EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                        },
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
                                Navigator.pushNamed(context, '/setup/details');
                              },
                              child: Text('Update Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xffDB5461))),
                            ))),
                ]
              ),
          )
        )
    );
  }
  sendSignal() async{
    FTPConnect ftpConnect = FTPConnect('example.com', user:'oli', pass:'oli');
    File signal = File('OLI-COMMAND');
    signal.openWrite();
    await signal.writeAsString("MAP");
    await ftpConnect.connect();
    bool res = await ftpConnect.uploadFileWithRetry(signal, pRetryCount: 2);
    await ftpConnect.disconnect();
  }
}
