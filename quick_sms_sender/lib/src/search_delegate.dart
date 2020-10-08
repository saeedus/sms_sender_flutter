import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'contact_select.dart';
import 'package:contacts_service/contacts_service.dart';

class Search extends SearchDelegate {
  final Map contactList;
  Search(this.contactList);

  final BehaviorSubject<Iterable<Contact>> readContactsStreamSearch =
  BehaviorSubject();

  void dispose() {
    readContactsStreamSearch.close();
  }

  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget buildResults(BuildContext context) {
    return Container();
  }

  Widget buildSuggestions(BuildContext context) {
    List<bool> isChecked = List<bool>();
    List<String> selectedContacts = List<String>();

    final Iterable<Contact> _contacts = this.contactList['contact'];
    readContactsStreamSearch.sink.add(_contacts);
    for (int i = 0; i < _contacts.length; i++) {
      isChecked.add(false);
    }

    return StreamBuilder<Iterable<Contact>>(
      stream: readContactsStreamSearch.stream,
      builder: (final context, final snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
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
                      child: Text(snapshot.data.elementAt(index).displayName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 36),
                  ],
                ),
              ),
              onChanged: (bool value) {
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
              },
            );
          },
        );
      },
    );
  }

}
