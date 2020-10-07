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
                splashColor: Colors.blueAccent[100],
                minWidth: 156,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                  color: Colors.transparent,
                  onPressed: _pickFile,
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'FILE',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ButtonTheme(
                minWidth: 156,
                splashColor: Colors.blueAccent[100],
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                      side: BorderSide(color: Colors.blue),
                  ),
                  color: Colors.transparent,
                  onPressed: _pickContact,
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'CONTACT',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ButtonTheme(
                minWidth: 156,
                splashColor: Colors.blueAccent[100],
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                      side: BorderSide(color: Colors.blue),
                  ),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.pushNamed(context, AppData.pageRouteArchiveContact);
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'ARCHIVED',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
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
