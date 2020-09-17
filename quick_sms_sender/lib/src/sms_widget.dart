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
  final _simCardProvider = new SimCardsProvider();
  final BehaviorSubject<String> _contactStringBehavior = BehaviorSubject();
  SimCard _simCard;
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
    _readContactString();
  }

  @override
  void dispose() {
    super.dispose();
    _contactStringBehavior.close();
  }

  ///if file a .txt file is chosen it'll read from the file
  ///else, it'll read from local contact
  void _readContactString() async {
    if (this.widget.data['file'] != null) {
      final File _file = this.widget.data['file'];
      String contacts = await _file.readAsString();
      _contactStringBehavior.sink.add(contacts);
    } else {
      final List<String> _numbers = this.widget.data['selectedNums'];
      String contacts = _numbers.join(",");
      _contactStringBehavior.sink.add(contacts);

      print('NUMBERS ARE HERE');
      print(_numbers);
    }
  }

  _onError(_error) {
    debugPrint(_error.toString());
  }


  void sendSms() async {
    SmsSender _messageSender = new SmsSender();
    String address = _contactStringBehavior.value;
    address.replaceAll('\n', '');
    address.replaceAll(' ', '');
    final List<String> _contactList = address.split(',');
    final String _messageData = messageController.text;
    List<StreamSubscription> _list = List();
    for (int i = 0; i < _contactList.length; i++) {
      final _contactNumber = _contactList[i];
      if (_contactNumber != null && _contactNumber.isNotEmpty) {
        final _message = SmsMessage(_contactNumber, _messageData);
        final StreamSubscription _t = _message.onStateChanged.listen((state) {
          if (state == SmsMessageState.Sent && i == _contactList.length - 1) {
            Navigator.pushNamed(context, AppData.pageRoutSent);
          }
        });
        _list.add(_t);
        await _messageSender
            .sendSms(_message, simCard: _simCard)
            .catchError(_onError);
      }
    }
  }

  void loadSimCardOne() async {
    List<SimCard> _cards = await _simCardProvider.getSimCards();
    _simCard = _cards.first;
  }

  void loadSimCardTwo() async {
    List<SimCard> _cards = await _simCardProvider.getSimCards();
    _simCard = _cards.last;
  }

  void simSelect() {
    if (selectedRadio == 1) {
      loadSimCardOne();
      print(selectedRadio);
    } else if (selectedRadio == 2) {
      loadSimCardTwo();
      print(selectedRadio);
    }
  }

  setSelectedRadio(int simVal) {
    setState(() {
      selectedRadio = simVal;
    });
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
            tooltip: 'Previous page',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Write Message',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 19,
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: <Widget>[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(6),
                child: TextField(
                  maxLines: 5,
                  autofocus: false,
                  controller: messageController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300], width: 2),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(18)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300], width: 2),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(18)),
                    ),
                    hintText: 'Enter message...',
                  ),
                ),
              ),

              SizedBox(height: 18),

              //radiobutton
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('SIM 1',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      setSelectedRadio(val);
                      simSelect();
                    },
                  ),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                      simSelect();
                    },
                  ),
                  Text('SIM 2',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18),

              Text(
                'Recipients:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 5),

              StreamBuilder<String>(
                stream: _contactStringBehavior.stream,
                builder: (final context, final snapshot) {
                  if (snapshot.hasData) {
                    final String contacts = snapshot.data.replaceAll('\n', '');
                    final List<String> _data =
                        contacts.replaceAll(' ', '').split(',');
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    spreadRadius: 1.5,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              height: 35,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${_data[index]}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 12),
                        CircularProgressIndicator(
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Send message',
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
