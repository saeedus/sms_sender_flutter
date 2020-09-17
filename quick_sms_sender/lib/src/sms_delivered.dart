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
          elevation: 2,
          leading: IconButton(
            color: Colors.black54,
            tooltip: 'Previous page',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Delivery Status',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 19,
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
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
