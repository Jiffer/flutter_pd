package com.niusounds.flutter_pd

import androidx.annotation.NonNull
import com.niusounds.flutter_pd.impl.PdImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** FlutterPdPlugin */
class FlutterPdPlugin : FlutterPlugin, ActivityAware {
    private var flutterPd: FlutterPd? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val flutterPd = FlutterPd(
            context = flutterPluginBinding.applicationContext,
            assetPathResolver = flutterPluginBinding.asAssetPathResolver(),
            pd = PdImpl(flutterPluginBinding.applicationContext)
        )
        connect(flutterPluginBinding.binaryMessenger, flutterPd)
        this.flutterPd = flutterPd
    }

    private fun connect(binaryMessenger: BinaryMessenger, flutterPd: FlutterPd) {
        val handler = DartCallHandler(flutterPd)
        MethodChannel(binaryMessenger, "flutter_pd/method")
            .setMethodCallHandler(handler)
        EventChannel(binaryMessenger, "flutter_pd/event")
            .setStreamHandler(handler)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        flutterPd?.dispose()
        flutterPd = null
    }

    override fun onDetachedFromActivity() {
        flutterPd?.activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        flutterPd?.activityBinding = binding
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterPd?.activityBinding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        flutterPd?.activityBinding = null
    }
}
