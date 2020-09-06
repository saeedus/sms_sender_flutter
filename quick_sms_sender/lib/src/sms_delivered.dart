import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmsDelivered extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmsDeliveredState();
  }
}

class _SmsDeliveredState extends State<SmsDelivered> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Quick Message',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Message sent successfully!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
          ),
        ),
        );
  }
}
