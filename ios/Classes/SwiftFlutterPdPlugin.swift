import Flutter
import UIKit

public class SwiftFlutterPdPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_pd/method", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // TODO: implementation
    switch call.method {
    case "checkPermission":
      result(true)

    case "startPd":
      result(nil)

    case "stopPd":
      result(nil)
      //   stopPd()

    case "openAsset":
      result(1)
      //   val pdFileAssetPath = call.arguments as? String
      //       ?: throw PdException("argument is missing", "openAsset() require an argument String")
      //   result.success(openAsset(pdFileAssetPath))

    case "close":
      result(nil)
      //   val patchHandle = call.arguments as? Int
      //       ?: throw PdException("argument is missing", "close() require an argument Int")

      //   close(patchHandle)
      //   result.success(null)
      // }

    case "startAudio":
      result(nil)
      //   val requireInput = call.argument<Boolean>("requireInput") ?: true
      //   startAudio(requireInput)
      //   result.success(null)
      // }

    case "send":
      result(nil)
      //   val receiver = call.argument<String>("receiver")
      //       ?: throw PdException("argument is missing", "receiver is required")
      //   val value = call.argument<Double>("value")
      //       ?: throw PdException("argument is missing", "value is required")

      //   send(receiver, value.toFloat())
      //   result.success(null)
      // }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
