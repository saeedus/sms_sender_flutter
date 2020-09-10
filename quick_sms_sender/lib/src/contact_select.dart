///-receive contact information using MaterialPageRoute argument
///-add radio buttons beside every contact
///-selected contacts will be send to sms_widget
///-then from sms_widget sms will be sent using already existing code.

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:contacts_service/contacts_service.dart';

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
  List<bool> _isChecked = List.filled(100, false);

  @override
  void initState() {
    super.initState();
    final Iterable<Contact> _contacts = this.widget.contacts['contact'];
    _readContactsStream.sink.add(_contacts);
  }

  void dispose() {
    super.dispose();
    _readContactsStream.close();
  }

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

        body: StreamBuilder<Iterable<Contact>>(
          stream: _readContactsStream.stream,
          builder: (final context, final snapshot) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data.elementAt(index).displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),

                    subtitle: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.elementAt(index).phones.length,
                      itemBuilder: (BuildContext context, int nestedIndex) {
                        return CheckboxListTile(
                          value: _isChecked[nestedIndex],
                          onChanged: (bool value) {
                            setState(() {
                              _isChecked[nestedIndex] = value;
                            });
                          },
                          title: Text(snapshot.data.elementAt(index).phones.elementAt(nestedIndex).value,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                          ),
                          ),
                        );
                      },
                    ),
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

          }
        ),
      ),
    );
  }
}