///-receive contact information using MaterialPageRoute argument
///-add radio buttons beside every contact
///-selected contacts will be send to sms_widget
///-then from sms_widget sms will be sent using already existing code.

import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  final Map contacts;
  SelectContact(this.contacts);
  @override
  State<StatefulWidget> createState() {
    return _SelectContactState();
  }
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            color: Colors.blue,
            tooltip: 'Previous page',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
      ),
    );
  }
}