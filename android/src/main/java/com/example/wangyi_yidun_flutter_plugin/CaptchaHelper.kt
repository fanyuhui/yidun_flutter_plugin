package com.netease.nis.flutter_captcha

import android.app.Activity
import android.content.Context
import com.example.wangyi_yidun_flutter_plugin.R
import com.netease.nis.captcha.Captcha
import com.netease.nis.captcha.CaptchaConfiguration
import com.netease.nis.captcha.CaptchaListener
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

/**
 * Created by hzhuqi on 2020/9/21
 */
class CaptchaHelper : CoroutineScope by MainScope() {
    private val TAG = "Captcha"
    var events: EventChannel.EventSink? = null

    fun showCaptcha(context: Activity, appKey: String, closeButton: Boolean,  controlBarStartUrl: String, controlBarMovingUrl: String, controlBarErrorUrl: String) {
        var config = CaptchaConfiguration.Builder()
                .captchaId(appKey)
                .listener(captchaListener)
                .debug(true)
                .hideCloseButton(closeButton)
                .controlBarImageUrl(controlBarStartUrl, controlBarMovingUrl, controlBarErrorUrl)
                .build(context);
        Captcha.getInstance().init(config).validate()
    }

    private var captchaListener: CaptchaListener = object : CaptchaListener {
        override fun onReady() {
        }

        override fun onValidate(result: String?, validate: String?, msg: String?) {
            var data = HashMap<String, String?>();
            data.put("result", result)
            data.put("validate", validate)
            data.put("msg", msg)
            launch(Dispatchers.Main) {
                events?.success(data)
            }
        }

        override fun onError(code: Int, msg: String?) {
            launch(Dispatchers.Main) {
                events?.error(code.toString(), msg, null)
            }
        }

        override fun onClose(p0: Captcha.CloseType?) {

        }
    }

}