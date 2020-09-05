import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_sms_sender/src/app_data.dart';

class LaunchScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LaunchScreenState();
  }
}

class _LaunchScreenState extends State<LaunchScreenWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, AppData.pageRoutePicker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
