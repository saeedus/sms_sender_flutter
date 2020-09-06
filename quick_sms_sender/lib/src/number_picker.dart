import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_sms_sender/src/app_data.dart';

class NumberPickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NumberPickerState();
  }
}

class _NumberPickerState extends State<NumberPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
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
          body: Container(
            child: Center(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: RaisedButton(
                    onPressed: _pickFile,
                    child: Text('OPEN FILES'),
                  ),
                ),
                width: MediaQuery.of(context).size.width - 48,
              ),
            ),
          ),
        ),
      ),
      color: Colors.red,
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
}
