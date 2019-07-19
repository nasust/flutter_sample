import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:simple_logger/simple_logger.dart';

final logger = SimpleLogger()..mode = LoggerMode.print;

void main() {
  enableFlutterDriverExtension();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Platform Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Platform Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const METHOD_CHANNEL_NAME = "com.nasust.platform_channels/method";
  static const EVENT_CHANNEL_NAME = "com.nasust.platform_channels/event";

  static const METHOD_CHANNEL = const MethodChannel(METHOD_CHANNEL_NAME);
  static const EVENT_CHANNEL = const EventChannel(EVENT_CHANNEL_NAME);

  @override
  void initState() {
    super.initState();
    EVENT_CHANNEL.receiveBroadcastStream().listen(_eventListener);
  }

  void _callPlatformMethod() async {
    try {
      final value = await METHOD_CHANNEL.invokeMethod("helloWorld");
      logger.info('Platform Method Result: ' + value);
    } catch (e) {
      logger.warning(e.toString());
    }
  }

  void _eventListener(dynamic obj) {
    logger.info('Platform Event Result: ' + obj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: _callPlatformMethod,
                child: Text("Call Platform Method"))
          ],
        ),
      ),
    );
  }
}
