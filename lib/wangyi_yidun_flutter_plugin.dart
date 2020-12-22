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
     loadingImage 自定义loading
     loadingType loading的类型 支持 gif png jpg
     loadingText 加载文字
     slideIcon        滑块图片image
     slideIconSuccess   滑动成功 image
     slideIconMoving  滑动中image
     slideIconError 滑动错误image
    */

  static Future<Void> setup({
    String appKey,
    bool closeButton,
    String loadingImage,
    String loadingType,
    String loadingText,
    String slideIcon,
    String slideIconSuccess,
    String slideIconMoving,
    String slideIconError,
  }) {
    Map<String, Object> map = {
      'appKey': appKey,
      'closeButton': closeButton,
      'loadingImage': loadingImage,
      'loadingType': loadingType,
      'loadingText': loadingText,
      'slideIcon': slideIcon,
      'slideIconSuccess': slideIconSuccess,
      'slideIconMoving': slideIconMoving,
      'slideIconError': slideIconError,
    };
  return  _channel.invokeMethod('setup', map);
  }
}
