import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:quick_sms_sender/src/contact_select.dart';

class Search extends SearchDelegate {
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
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('hi'),
        );
      },
    );
  }
}
