import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class Search extends SearchDelegate {
  final Map contactList;
  Search(this.contactList);
  List<String> contactListToSearch = List<String>();

  void contactToList() {
    final Iterable<Contact> _contacts = this.contactList['contact'];
    _contacts.forEach((element) {
      contactListToSearch.add(element.displayName);
    });
    print(_contacts.length);
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
    contactToList();
    List<String> suggestionList = [];

    query.isEmpty
      ? suggestionList = []
      : suggestionList.addAll(contactListToSearch.where((element) => element.startsWith(query)));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList.elementAt(index) + ' (' + suggestionList.length.toString() + ')' + index.toString()),
        );
      },
    );
  }
}
