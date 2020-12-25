import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

class WangyiYidunFlutterPlugin {

  static const MethodChannel _channel = const MethodChannel('wangyi_yidun_flutter_plugin');

  // 测试通道是否成功
  static Future<String> get platformVersion async {
    return await _channel.invokeMethod('show');
  }

  /*
     appKey  验证码
     loadingText 加载文字
     slideIcon        滑块图片image
     slideIconMoving  滑动中image
     slideIconError 滑动错误image
    */

  static Future<Void> setup({
    String appKey,
    bool closeButton,
    String slideIcon,
    String slideIconMoving,
    String slideIconError,
  }) {
    Map<String, Object> map = {
      'appKey': appKey,
      'closeButton': closeButton,
      'slideIcon': slideIcon,
      'slideIconMoving': slideIconMoving,
      'slideIconError': slideIconError,
    };
  return  _channel.invokeMethod('setup', map);
  }
}
