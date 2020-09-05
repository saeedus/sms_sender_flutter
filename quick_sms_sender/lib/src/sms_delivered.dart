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
          title: Text('status'),
        ),
        body: Text('Message sent successfully!'),
      ),
    );
  }
}
