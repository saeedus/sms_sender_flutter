import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:quick_sms_sender/src/app_data.dart';
import 'package:contacts_service/contacts_service.dart';

class NumberPickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NumberPickerState();
  }
}

class _NumberPickerState extends State<NumberPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Exit app',
            color: Colors.blue,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          title: Text(
            'Quick Message',
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                color: Colors.transparent,
                elevation: 0,
                onPressed: _pickFile,
                textColor: Colors.white70,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.blueAccent,
                        Colors.lightBlue,
                        Colors.lightBlueAccent
                      ]
                    ),
                  ),
                  padding: EdgeInsets.all(18),
                  child: Text('Choose file',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),

              RaisedButton(
                color: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  _pickContact();
                },
                textColor: Colors.white70,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.pink[600],
                          Colors.pink[400],
                          Colors.pink[300],
                        ]
                    ),
                  ),
                  padding: EdgeInsets.all(18),
                  child: Text('Choose contact',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickFile() async {
    File files = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (files != null) {
      Navigator.pushNamed(context, AppData.pageRoutSendSms,
          arguments: {'file': files});
    }
  }

  void _pickContact() async{
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    if(contacts != null) {
      Navigator.pushNamed(context, AppData.pageRoutContactSelect,
        arguments: {'contact': contacts});
    }
  }
}
