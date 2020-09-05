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
  final BehaviorSubject<String> _smsStatusSendBehavior = BehaviorSubject();

//strambuilder class
  // Stream<int> contactStream = (() async* {
  //   await Future<void>.delayed(Duration(seconds: 1));
  //   yield 1;
  //   await Future<void>.delayed(Duration(seconds: 1));
  // })();

  @override
  void initState() {
    super.initState();

    _readContactString();
  }

  @override
  void dispose() {
    super.dispose();
    _contactStringBehavior.close();
    _smsStatusSendBehavior.close();
  }

  void _readContactString() async {
    final File _file = this.widget.data['file'];
    String contacts = await _file.readAsString();
    _contactStringBehavior.sink.add(contacts);
    debugPrint(_contactStringBehavior.value ?? '');
  }



  void sendSms() async {
    SmsSender _messageSender = new SmsSender();
    String address = _contactStringBehavior.value;
    final List<String> _contactList = address.split('\n');
    final SimCard _selectedSim = await _selectSim();
    final String _messageData = messageController.text;
    for (int i = 0; i < _contactList.length; i++) {
      final _contactNumber = _contactList[i];
      debugPrint(_contactNumber);
      if (_contactNumber != null && _contactNumber.isNotEmpty) {
        _smsStatusSendBehavior.sink.add('sending SMS to $_contactNumber');
        final _message = SmsMessage(_contactNumber, _messageData);
        await _messageSender.sendSms(_message, simCard: _selectedSim);
      }
    }
  }

  Future<SimCard> _selectSim() async {
    SimCardsProvider sim = new SimCardsProvider();
    List<SimCard> card = await sim.getSimCards();
    card.forEach((element) {
      debugPrint(element.imei);
    });

    print(card.toString());
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
          TextField(
            controller: messageController,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter message'),
          ),
          Text('Message will be sent to the following contacts.\n'),
          StreamBuilder<String>(
            stream: _contactStringBehavior.stream,
            builder: (final context, final snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          StreamBuilder<String>(
            stream: _smsStatusSendBehavior.stream,
            builder: (_context, _snap) {
              if (_snap.hasData) {
                return Center(
                  child: Text(_snap.data),
                );
              }
              return SizedBox();
            },
          )
        ]),
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
