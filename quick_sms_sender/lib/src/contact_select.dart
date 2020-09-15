///-receive contact information using MaterialPageRoute argument
///-add radio buttons beside every contact
///-selected contacts will be send to sms_widget
///-then from sms_widget sms will be sent using already existing code.

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:sms/sms.dart';


class SelectContact extends StatefulWidget {
  final Map contacts;
  SelectContact(this.contacts);
  @override
  State<StatefulWidget> createState() {
    return _SelectContactState();
  }
}

class _SelectContactState extends State<SelectContact> {
  final BehaviorSubject<Iterable<Contact>> _readContactsStream = BehaviorSubject();
  List<bool> _isChecked = List<bool>();
  List<String> _selectedContacts = List<String>();

  @override
  void initState() {
    super.initState();
    final Iterable<Contact> _contacts = this.widget.contacts['contact'];
    _readContactsStream.sink.add(_contacts);
    for(int i = 0; i < _contacts.length; i++) {
      _isChecked.add(false);
    }
  }

  void dispose() {
    super.dispose();
    _readContactsStream.close();
  }

  //hardcoded
  void sendSMS() {
    SmsSender sender = SmsSender();
    if(_selectedContacts != null) {
      _selectedContacts.forEach((number) {
        sender.sendSms(SmsMessage(number, 'hi'));
      });
    }
  }

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

        body: StreamBuilder<Iterable<Contact>>(
          stream: _readContactsStream.stream,
          builder: (final context, final snapshot) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: _isChecked[index],
                    title: Text(snapshot.data.elementAt(index).displayName),
                    onChanged: (bool value) {
                        if(value == true) {
                          setState(() {
                            _isChecked[index] = true;
                            _selectedContacts.add(snapshot.data.elementAt(index).phones.elementAt(0).value);
                          });
                        }
                        print(_selectedContacts);
                    },
                  );
                },
              );
          },
        ),

        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Send message',
          icon: Icon(Icons.send),
          label: Text('SEND'),
          onPressed: () {
            sendSMS();
          },
        ),
      ),
    );
  }
}