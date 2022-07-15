package com.niusounds.flutter_pd

import com.niusounds.flutter_pd.exception.PdException

import androidx.annotation.NonNull
import com.niusounds.flutter_pd.impl.PdImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import android.util.Log
import java.lang.Exception
/** FlutterPdPlugin */
class FlutterPdPlugin: FlutterPlugin, MethodCallHandler {
  private var flutterPd: FlutterPd? = null
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel : EventChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // MethodChannel
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_pd/method")
    methodChannel.setMethodCallHandler(this)
    // EventChannel
//    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_pd/event")
//    eventChannel.setStreamHandler(streamHandler)

    // instantiate FlutterPd
    flutterPd = FlutterPd(
      context = flutterPluginBinding.applicationContext,
      assetPathResolver = flutterPluginBinding.asAssetPathResolver(),
      pd = PdImpl(flutterPluginBinding.applicationContext)
    )
//    connect(flutterPluginBinding.binaryMessenger, flutterPd)
    this.flutterPd = flutterPd
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "checkPermission") {
      Log.d("flutter_pd", "checkPermission not implemented")
//      checkPermission {
//        result.success(it)
//      }
    }
    else if (call.method == "startPd") {
      Log.d("flutter_pd", "calling startPd()")
      if(flutterPd == null){
        Log.d("flutter_pd", "aint no...")
      }
      flutterPd?.startPd { result.success(null) }
    }
    else if(call.method == "stopPd"){
      flutterPd?.stopPd()
    }
    else if (call.method == "openAsset") {
      val pdFileAssetPath = call.arguments as? String
        ?: throw PdException("argument is missing", "openAsset() require an argument String")
      result.success(flutterPd?.openAsset(pdFileAssetPath))
    }
    else if (call.method == "close") {
      val patchHandle = call.arguments as? Int
        ?: throw PdException("argument is missing", "close() require an argument Int")

      flutterPd?.close(patchHandle)
      result.success(null)
    }
    else if (call.method == "startAudio") {
      val requireInput = call.argument<Boolean>("requireInput") ?: true
      flutterPd?.startAudio(requireInput)
      result.success(null)
    }
    else if (call.method == "send") {
      val receiver = call.argument<String>("receiver")
        ?: throw PdException("argument is missing", "receiver is required")
      val value = call.argument<Double>("value")
        ?: throw PdException("argument is missing", "value is required")

      flutterPd?.send(receiver, value.toFloat())
      result.success(null)
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }
}
