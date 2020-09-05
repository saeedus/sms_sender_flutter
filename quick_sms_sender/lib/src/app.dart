import 'package:flutter/material.dart';
import 'package:quick_sms_sender/src/app_data.dart';
import 'package:quick_sms_sender/src/launch_screen.dart';
import 'package:quick_sms_sender/src/number_picker.dart';
import 'package:quick_sms_sender/src/sms_delivered.dart';
import 'package:quick_sms_sender/src/sms_widget.dart'; // for file_picker plugin

class App extends StatefulWidget {
  createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LaunchScreenWidget(),
      onGenerateRoute: _generateRout,
    );
  }

  MaterialPageRoute _generateRout(final RouteSettings settings) {
    Widget _page;

    if (settings.name == AppData.pageRoutePicker) {
      _page = NumberPickerWidget();
    } else if (settings.name == AppData.pageRoutSendSms) {
      _page = SmsWidget(settings.arguments);
    } else if (settings.name == AppData.pageRoutSent) {
      _page = SmsDelivered();
    }

    return MaterialPageRoute(
        builder: (_context) {
          return _page;
        },
        settings:
            RouteSettings(name: settings.name, arguments: settings.arguments));
  }
}
