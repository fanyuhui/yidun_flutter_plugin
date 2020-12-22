import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wangyi_yidun_flutter_plugin/wangyi_yidun_flutter_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  var eventChannel = const EventChannel("yd_captcha_flutter_event_channel");

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onData, onError: _onError);
    initPlatformState();
  }

  void _onData(response) {
    var validate = (response as Map)['validate'];
    if (validate != null && !validate.isEmpty) {
      print("来自Flutter的提示：验证通过, token:$validate");
    } else {
      print("来自Flutter的提示：验证失败");
    }
  }
  _onError(Object error) {
    PlatformException exception = error;
    print("来自Flutter的提示，加载验证码出现错误:" + exception.message);
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await WangyiYidunFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

    void showCaptcha() async {
     // WangyiYidunFlutterPlugin.showCaptcha('deecf3951a614b71b4b1502c072be1c1');
    WangyiYidunFlutterPlugin.setup(appKey: 'deecf3951a614b71b4b1502c072be1c1');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            child: Text('Running on: $_platformVersion\n'),
            onTap: (){
              showCaptcha();
            },
          ),
        ),
      ),
    );
  }
}
