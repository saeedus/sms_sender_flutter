import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:quick_sms_sender/src/app_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class SmsWidget extends StatefulWidget {
  final Map data;
  SmsWidget(this.data);
  @override
  State<StatefulWidget> createState() {
    return _SmsState();
  }
}

class _SmsState extends State<SmsWidget> {
  final messageController = TextEditingController();

  //streambuilder's behavioursubject
  final BehaviorSubject<String> _contactStringBehavior = BehaviorSubject();

  @override
  void initState() {
    super.initState();

    _readContactString();
  }

  @override
  void dispose() {
    super.dispose();
    _contactStringBehavior.close();
  }

  void _readContactString() async {
    final File _file = this.widget.data['file'];
    String contacts = await _file.readAsString();
    _contactStringBehavior.sink.add(contacts);
    debugPrint(_contactStringBehavior.value ?? '');
  }


  _onError(_error){
    debugPrint(_error.toString());
  }

  void sendSms() async {
    SmsSender _messageSender = new SmsSender();
    String address = _contactStringBehavior.value;
    address.replaceAll('\n', '');
    address.replaceAll(' ', '');
    final List<String> _contactList = address.split(',');
    final String _messageData = messageController.text;
    for (int i = 0; i < _contactList.length; i++) {
      final _contactNumber = _contactList[i];
      if (_contactNumber != null && _contactNumber.isNotEmpty) {
        final _message = SmsMessage(_contactNumber, _messageData);
        _message.onStateChanged.listen((state) {
          if(state == SmsMessageState.Sent){
            Navigator.pushNamed(context, AppData.pageRoutSent, arguments: {'number': _contactNumber});
          }
        });
        await _messageSender.sendSms(_message).catchError(_onError);
      }
    }
  }

  Future<SimCard> _selectSim() async {
    SimCardsProvider sim = new SimCardsProvider();
    List<SimCard> card = await sim.getSimCards();
    return card.last;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SMS SENDER'),
        ),
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.all(24),
            child: TextField(
              minLines: 3,
              maxLines: 4,
              autofocus: false,
              controller: messageController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                hintText: 'Enter message',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text('Recipients: \n',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                StreamBuilder<String>(
                  stream: _contactStringBehavior.stream,
                  builder: (final context, final snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.replaceAll('\n', ''));
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Press to send sms',
          icon: Icon(Icons.send),
          label: Text('SEND'),
          onPressed: () {
            sendSms();
          },
        ),
      ),
    );
  }
}
