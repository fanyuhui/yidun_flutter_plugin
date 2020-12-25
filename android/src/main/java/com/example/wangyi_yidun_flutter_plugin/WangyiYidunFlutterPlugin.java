package com.example.wangyi_yidun_flutter_plugin;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.netease.nis.flutter_captcha.CaptchaHelper;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * WangyiYidunFlutterPlugin
 */
public class WangyiYidunFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware
{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private EventChannel mEventChannel;
  private Activity mContext;
  private CaptchaHelper captchaHelper;
  private static String EVENT_CHANNEL = "yd_captcha_flutter_event_channel";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding)
  {
    captchaHelper = new CaptchaHelper();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "wangyi_yidun_flutter_plugin");
    channel.setMethodCallHandler(this);
    mEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), EVENT_CHANNEL);
    mEventChannel.setStreamHandler(new EventChannel.StreamHandler()
    {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events)
      {
        captchaHelper.setEvents(events);
      }

      @Override
      public void onCancel(Object arguments)
      {

      }
    });
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result)
  {
    if (call.method.equals("setup"))
    {
      if (mContext != null)
      {
        HashMap arguments = (HashMap) call.arguments();
        String appKey = (String) arguments.get("appKey");
        boolean closeButton = (boolean) arguments.get("closeButton");
        String slideIcon = (String) arguments.get("slideIcon");
        String slideIconMoving = (String) arguments.get("slideIconMoving");
        String slideIconError = (String) arguments.get("slideIconError");
        captchaHelper.showCaptcha(mContext, appKey, closeButton, slideIcon, slideIconMoving, slideIconError);
      }

    } else
    {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding)
  {
    channel.setMethodCallHandler(null);
  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding)
  {
    this.mContext = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges()
  {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding)
  {
    this.mContext = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity()
  {

  }
}
