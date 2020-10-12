import 'package:flutter/cupertino.dart';
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

  Widget _defaultBar() {
    return AppBar(
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
    );
  }

  Widget _selectedBar() {
    return AppBar(
      backgroundColor: Color.fromRGBO(139, 202, 202, 1),
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
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        selectedContacts.length.toString() + ' Selected',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 20,
          color: Colors.grey[800],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _floatingButton() {
    if (selectedContacts.isNotEmpty) {
      return FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(139, 202, 202, 1),
        icon: Icon(Icons.done),
        label: Text('DONE'),
        onPressed: sendContacts,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: selectedContacts.isEmpty ? _defaultBar() : _selectedBar(),
        body: StreamBuilder<Iterable<Contact>>(
          stream: readContactsStream.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        color: Color.fromRGBO(212, 244, 236, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        child: Text(
                          'Select All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () {
                          selectedContacts.clear();
                          for (int i = 0; i < snapshot.data.length; i++) {
                            if (snapshot.data.elementAt(i).phones.isNotEmpty) {
                              selectedContacts.add(snapshot.data
                                  .elementAt(i)
                                  .phones
                                  .elementAt(0)
                                  .value);
                            }
                          }
                          setState(() {
                            for (int i = 0; i < snapshot.data.length; i++) {
                              isChecked[i] = true;
                            }
                          });
                          print(selectedContacts);
                        },
                      ),
                      SizedBox(width: 6),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        color: Color.fromRGBO(212, 244, 236, 1),
                        child: Text(
                          'Deselect All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () {
                          selectedContacts.clear();
                          setState(() {
                            for (int i = 0; i < snapshot.data.length; i++) {
                              isChecked[i] = false;
                            }
                            print(selectedContacts);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        activeColor: Color.fromRGBO(254, 168, 137, 1),
                        value: isChecked[index],
                        title: Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data
                                          .elementAt(index)
                                          .displayName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data
                                          .elementAt(index)
                                          .phones
                                          .length,
                                      itemBuilder: (context, index_2) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            snapshot.data
                                                .elementAt(index)
                                                .phones
                                                .elementAt(index_2)
                                                .value,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        );
                                      },
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
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: _floatingButton(),
      ),
    );
  }
}
