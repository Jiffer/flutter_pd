package com.niusounds.flutter_pd

import com.niusounds.flutter_pd.exception.PdException
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

/**
 * Converts messages from dart to [DartToNative] and respond to dart.
 * It separates Flutter specific types and [Any] from [DartToNative].
 */
class DartCallHandler(delegate: DartToNative) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler, DartToNative by delegate {
  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    try {
      when (call.method) {
        "checkPermission" -> {
          checkPermission {
            result.success(it)
          }
        }

        "startPd" -> {
          startPd { result.success(null) }
        }

        "stopPd" -> {
          stopPd()
        }

        "openAsset" -> {
          val pdFileAssetPath = call.arguments as? String
              ?: throw PdException("argument is missing", "openAsset() require an argument String")
          result.success(openAsset(pdFileAssetPath))
        }

        "close" -> {
          val patchHandle = call.arguments as? Int
              ?: throw PdException("argument is missing", "close() require an argument Int")

          close(patchHandle)
          result.success(null)
        }

        "startAudio" -> {
          val requireInput = call.argument<Boolean>("requireInput") ?: true
          startAudio(requireInput)
          result.success(null)
        }

        "send" -> {
          val receiver = call.argument<String>("receiver")
              ?: throw PdException("argument is missing", "receiver is required")
          val value = call.argument<Double>("value")
              ?: throw PdException("argument is missing", "value is required")

          send(receiver, value.toFloat())
          result.success(null)
        }

        else -> {
          result.notImplemented()
        }
      }
    } catch (e: PdException) {
      result.error(e.code, e.message, e.detail)
    } catch (e: Exception) {
      result.error("Unknown error", e.message, null)
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    (arguments as? Map<*, *>)?.let {
      val symbol = it["symbol"] as? String ?: return
      val id = it["id"] as? Int ?: return
      onListen(symbol, id, events::success)
    }
  }

  override fun onCancel(arguments: Any?) {
    (arguments as? Map<*, *>)?.let {
      val symbol = it["symbol"] as? String ?: return
      val id = it["id"] as? Int ?: return
      onCancel(symbol, id)
    }
  }
}