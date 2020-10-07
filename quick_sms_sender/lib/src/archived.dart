import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Archived extends StatefulWidget {
  final Map sentContacts;
  Archived(this.sentContacts);

  @override
  State<StatefulWidget> createState() {
    return ArchivedState();
  }
}

class ArchivedState extends State<Archived> {
  final BehaviorSubject<String> _archiveContacts = BehaviorSubject();
  final BehaviorSubject<int> _totalArchiveStream = BehaviorSubject();

  void dispose() {
    super.dispose();
    _totalArchiveStream.close();
    _archiveContacts.close();
  }

  @override
  void initState() {
    super.initState();
    _totalArchive();
    _createArchiveList();
  }

  void _createArchiveList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_totalArchiveStream.value.toString(), this.widget.sentContacts['archivedContacts']);
    String currentArchive = prefs.getString(_totalArchiveStream.value.toString());
    _archiveContacts.sink.add(currentArchive);
  }

  Future<void> _totalArchive() async {
    final prefs = await SharedPreferences.getInstance();
    final num = prefs.getInt('archiveNo');
    if(num != null) {
      _totalArchiveStream.sink.add(num);
    }
  }

  Future<void> incrementArchiveNo() async {
        final prefs = await SharedPreferences.getInstance();
        if(prefs.getInt('archiveNo') == null) {
          prefs.setInt('archiveNo', 0);
          _totalArchiveStream.sink.add(0);
        } else {
          int lastNumber = prefs.getInt('archiveNo');
          int currentNumber = ++lastNumber;
          prefs.setInt('archiveNo', currentNumber);
          _totalArchiveStream.sink.add(currentNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            color: Colors.black54,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.of(context).pop();
              Navigator.popUntil(context, ModalRoute.withName('/home/pciker'));
            },
          ),
          title: Text(
            'Archived Contacts',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 19,
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
        ),

        body: StreamBuilder(
          stream: _totalArchiveStream.stream,
          builder: (final context, final snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text('ARCHIVE $index',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 24),
                          ButtonTheme(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)
                            ),
                            child: StreamBuilder(
                              stream: _archiveContacts.stream,
                              builder: (final context, final snapshot2) {
                                if(snapshot2.hasData) {
                                  return FlatButton(
                                    color: Colors.blueAccent[100],
                                    child: Text('view'),
                                    onPressed: () async {
                                      final prefs = await SharedPreferences.getInstance();
                                      print(prefs.getString(index.toString()));
                                    },
                                  );
                                }
                                return CircularProgressIndicator();
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            for(int i = 0; i < 10;) {
              prefs.remove((i++).toString());
              print('removed $i');
            }
          },
        ),
      ),
    );
  }
}