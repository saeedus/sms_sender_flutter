import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quick_sms_sender/src/app_data.dart';
import 'package:contacts_service/contacts_service.dart';

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
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    if (contacts != null) {
      Navigator.pushNamed(context, AppData.pageRoutContactSelect,
          arguments: {'contact': contacts});
    }
  }

  void _prevContacts() {
    Navigator.pushNamed(context, AppData.pageRoutSendSms);
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quick Message',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 72),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 160,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0)),
                    color: Colors.blue,
                    textColor: Colors.white70,
                    onPressed: _pickFile,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        'Choose file',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0)),
                  color: Colors.red,
                  textColor: Colors.white70,
                  padding: const EdgeInsets.all(0.0),
                  onPressed: _pickContact,
                  child: Container(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Choose contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 84),
            Text(
              'Previously sent:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      // color: Colors.blue[100],
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Group 1',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '+8801842220598\n+8801531723118\n+8801521534263\n              ...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black26,
                            ),
                          ),
                          FlatButton(
                            color: Colors.white70,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text('View'),
                            onPressed: _prevContacts,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
