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
  SimCard _simCard;
  int selectedRadio;
  String contacts;

  //streambuilder's behavioursubject
  final BehaviorSubject<String> _contactStringBehavior = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
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
    print(contacts);
    _contactStringBehavior.sink.add(contacts);
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
          if (state == SmsMessageState.Sent) {
            Navigator.pushNamed(context, AppData.pageRoutSent).then((value) =>
                _list.forEach((element) {
                  element.cancel();
                }),);
          }
        });
        _list.add(_t);
        await _messageSender.sendSms(_message, simCard: _simCard).catchError(
            _onError);
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
    if(selectedRadio == 1) {
      loadSimCardOne();
      print(selectedRadio);
    }
    else if(selectedRadio == 2){
      loadSimCardTwo();
      print(selectedRadio);
    }
  }


// Changes the selected value on 'onChanged' click on each radio button
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
          elevation: 0,
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

        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6),
              child: TextField(
                maxLines: 5,
                autofocus: false,
                controller: messageController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 1),
                  ),
                  hintText: 'Enter message',
                ),
              ),
            ),

            SizedBox(height: 24),

            //radiobutton
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('SIM 1'),
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
                Text('SIM 2'),
              ],
            ),

            SizedBox(height: 24),

            Text('Recipients:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            StreamBuilder<String>(
              stream: _contactStringBehavior.stream,
              builder: (final context, final snapshot) {
                if (snapshot.hasData) {
                  final String contacts = snapshot.data.replaceAll('\n', '');
                  final List<String> _data = contacts.replaceAll(' ', '').split(',');
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12,),
                          child: Container(

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4)),

                              // BoxDecorationrationorderRadius.only(
                              //     topLeft: Radius.circular(10),
                              //     topRight: Radius.circular(10),
                              //     bottomLeft: Radius.circular(10),
                              //     bottomRight: Radius.circular(10)
                              // ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 1.5,
                                  blurRadius: 2,
                                  // offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 35,
                            // color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_data[index]}',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                  child: CircularProgressIndicator(),
                );
              },
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
