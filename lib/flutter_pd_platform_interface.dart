import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_pd_method_channel.dart';
import 'pd_event.dart';
import 'pd_file_handle.dart';

abstract class FlutterPdPlatform extends PlatformInterface {
  /// Constructs a FlutterPdPlatform.
  FlutterPdPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPdPlatform _instance = MethodChannelFlutterPd();

  /// The default instance of [FlutterPdPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPd].
  static FlutterPdPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPdPlatform] when
  /// they register themselves.
  static set instance(FlutterPdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Request a permission to access to microphone.
  Future<bool> checkPermission() async {
    throw UnimplementedError('checkPermission() not implemented');
  }

  Future<void> startPd() {
    throw UnimplementedError('startPd() not implemented');
  }

  Future<void> restartAudio(bool requestInput) {
    throw UnimplementedError('restartAudio() not implemented');
  }

  Future<void> stopPd() {
    throw UnimplementedError('checkPermission() not implemented');
  }

  Future<PdFileHandle> openAsset(String pdFileAssetPath) async {
    throw UnimplementedError('openAsset() not implemented');
  }

  /// Should only be called from [PdFileHandle.close]. Do not call this directly.
  Future<void> close(int patchHandle) {
    throw UnimplementedError('flutter_pd::close() not implemented');
  }

  Future<void> startAudio({bool? requireInput}) {
    throw UnimplementedError('startAudio() not implemented');
  }

  Future<void> send(String receiverName, double value) {
    throw UnimplementedError('flutter_Pd::send() not implemented');
  }

  Stream<PdEvent> receive(String symbol) {
    throw UnimplementedError('checkPermission() not implemented');
  }
}
