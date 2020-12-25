import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class WangyiYidunFlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('wangyi_yidun_flutter_plugin');

  // 测试通道是否成功
  static Future<String> get platformVersion async {
    return await _channel.invokeMethod('show');
  }

  static Future<String> getDemo() async {
    return await _channel.invokeMethod('getDemo');
  }

  /*
     appKey  验证码
     loadingImage 自定义loading
     loadingType loading的类型 支持 gif png jpg
     loadingText 加载文字
     slideIcon        滑块图片image
     slideIconSuccess   滑动成功 image
     slideIconMoving  滑动中image
     slideIconError 滑动错误image
    */

  static Future<Void> setup({
    @required String appKey,
    bool closeButton = false,
    String slideIcon = '',
    String slideIconSuccess = '',
    String slideIconMoving = '',
    String slideIconError = '',
  }) {
    Map<String, Object> map = {
      'appKey': appKey,
      'closeButton': closeButton,
      'slideIcon': slideIcon,
      'slideIconMoving': slideIconMoving,
      'slideIconError': slideIconError,
    };
    return _channel.invokeMethod('setup', map);
  }
}
