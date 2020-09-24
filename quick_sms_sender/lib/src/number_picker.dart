import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quick_sms_sender/src/app_data.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NumberPickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NumberPickerState();
  }
}

class _NumberPickerState extends State<NumberPickerWidget> {
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

  void _pickContact() async {
    await Permission.contacts.request();
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    if (contacts != null) {
      Navigator.pushNamed(context, AppData.pageRoutContactSelect,
          arguments: {'contact': contacts});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          title: Text(
            'Group Message',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 22,
              color: Colors.black54,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 170,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  textColor: Colors.white70,
                  onPressed: _pickFile,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'File',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ButtonTheme(
                minWidth: 170,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  textColor: Colors.white70,
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {

                  },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Group',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ButtonTheme(
                minWidth: 170,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  textColor: Colors.white70,
                  onPressed: _pickContact,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
}
