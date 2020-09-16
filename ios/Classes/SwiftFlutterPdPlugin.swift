import Flutter
import UIKit
import libpd_ios

public class SwiftFlutterPdPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, PdListener {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_pd/method",
      binaryMessenger: registrar.messenger()
    )
    let eventChannel = FlutterEventChannel(
      name: "flutter_pd/event",
      binaryMessenger: registrar.messenger()
    )
    let instance = SwiftFlutterPdPlugin(registrar: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)
  }

  private let registrar: FlutterPluginRegistrar
  private var audioController: PdAudioController?
    private var dispatcher: PdDispatcher?
  private var fileHandles: [Int: UnsafeMutableRawPointer] = [:]

  public init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkPermission":
      result(true)
    case "startPd":
      audioController = PdAudioController()
      dispatcher = PdDispatcher()
      PdBase.setDelegate(dispatcher)
      result(nil)
    case "stopPd":
      audioController = nil
      result(nil)
    case "openAsset":
      guard let pdFileAssetPath = call.arguments as? String else {
        result(0)
        return
      }
      let assetPath = registrar.lookupKey(forAsset: pdFileAssetPath)
      guard let path = Bundle.main.path(forResource: assetPath, ofType: nil) else {
        result(0)
        return
      }
      let url = URL(fileURLWithPath: path)
      let fileName = url.lastPathComponent
      let directory = url.deletingLastPathComponent().path
      guard let handle = PdBase.openFile(fileName, path: directory) else {
        result(0)
        return
      }

      let hashValue = handle.hashValue
      fileHandles[hashValue] = handle
      result(hashValue)
    case "close":
      guard let hashValue = call.arguments as? Int, let rawPointer = fileHandles[hashValue] else {
        result(nil)
        return
      }
      PdBase.closeFile(rawPointer)
      result(nil)
    case "startAudio":
      guard let args = call.arguments as? [String: Any?],
        let requireInput = args["requireInput"] as? Bool
      else {
        result(nil)
        return
      }
      audioController?.configurePlayback(
        withSampleRate: 44100,
        numberChannels: 2,
        inputEnabled: requireInput,
        mixingEnabled: false
      )
      audioController?.isActive = true
      audioController?.print()
      result(nil)
    case "send":
      guard let args = call.arguments as? [String: Any?],
        let receiver = args["receiver"] as? String,
        let value = args["value"] as? Double
      else {
        result(nil)
        return
      }

      PdBase.send(Float(value), toReceiver: receiver)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    guard let args = arguments as? [String: Any?],
      let symbol = args["symbol"] as? String,
      let id = args["id"] as? Int
    else {
      return FlutterError(code: "invalid arguments", message: "", details: nil)
    }
    
    dispatcher?.add(PdEventListener(id: id, callback: events), forSource: symbol)
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    guard let args = arguments as? [String: Any?],
      let symbol = args["symbol"] as? String,
      let id = args["id"] as? Int
    else {
      return FlutterError(code: "invalid arguments", message: "", details: nil)
    }
    
    if let listener = PdEventListener.remove(id: id) {
        dispatcher?.remove(listener, forSource: symbol)
    }
    return nil
  }
}
