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
            title: Text('PICK A FILE'),
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

    //String contact = await files.readAsString(); //provide filepath
    //contact.split('\n').forEach((number) {
    //sender.sendSms(new SmsMessage(number, myController.text));
    //});
    if (files != null) {
      Navigator.pushNamed(context, AppData.pageRoutSendSms,
          arguments: {'file': files});
    }

    /*
    FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    ).then((file) {
      Navigator.pushNamed(context, AppData.pageRoutSendSms, arguments: {
        'file': file,
        'name': 'sagor',
        'simiple_array': ['mony', 10, 11.1]
      });
    });
    */
  }
}
