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
          leading: IconButton(
            color: Colors.black54,
            tooltip: 'Previous page',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Quick Message',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: Colors.black54,
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
