///-receive contact information using MaterialPageRoute argument
///-add radio buttons beside every contact
///-selected contacts will be send to sms_widget
///-then from sms_widget sms will be sent using already existing code.

import 'package:flutter/material.dart';
import 'package:quick_sms_sender/src/app_data.dart';
import 'package:quick_sms_sender/src/search_delegate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:contacts_service/contacts_service.dart';

class SelectContact extends StatefulWidget {
  final Map contacts;
  SelectContact(this.contacts);
  @override
  State<StatefulWidget> createState() {
    return SelectContactState();
  }
}

class SelectContactState extends State<SelectContact> {
  final BehaviorSubject<Iterable<Contact>> readContactsStream =
      BehaviorSubject();
  List<bool> isChecked = List<bool>();
  List<String> selectedContacts = List<String>();

  @override
  void initState() {
    super.initState();
    final Iterable<Contact> _contacts = this.widget.contacts['contact'];
    readContactsStream.sink.add(_contacts);
    for (int i = 0; i < _contacts.length; i++) {
      isChecked.add(false);
    }
  }

  void sendContacts() {
    if (selectedContacts[0] != '') {
      Navigator.pushNamed(context, AppData.pageRoutSendSms,
          arguments: {'selectedNums': selectedContacts});
    }
  }

  void dispose() {
    super.dispose();
    readContactsStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: Search(this.widget.contacts));
              },
              icon: Icon(Icons.search),
              color: Colors.black54,
            ),
          ],
          leading: IconButton(
            color: Colors.black54,
            tooltip: 'Previous page',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Select Contact',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 19,
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: StreamBuilder<Iterable<Contact>>(
          stream: readContactsStream.stream,
          builder: (final context, final snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  value: isChecked[index],
                  title: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8),
                          child: Column(
                            children: <Widget>[
                              Text(
                                snapshot.data.elementAt(index).displayName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(snapshot.data
                                  .elementAt(index)
                                  .phones
                                  .elementAt(0)
                                  .value,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 36),
                      ],
                    ),
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      isChecked[index] = value;
                      if (value) {
                        selectedContacts.add(snapshot.data
                            .elementAt(index)
                            .phones
                            .elementAt(0)
                            .value);
                        print(selectedContacts);
                      } else {
                        selectedContacts.remove(snapshot.data
                            .elementAt(index)
                            .phones
                            .elementAt(0)
                            .value);
                        print(selectedContacts);
                      }
                    });
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.done),
          label: Text('DONE'),
          onPressed: sendContacts,
        ),
      ),
    );
  }
}
