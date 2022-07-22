import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_pd_platform_interface.dart';
import 'pd_event.dart';
import 'pd_file_handle.dart';

/// An implementation of [FlutterPdPlatform] that uses method channels.
class MethodChannelFlutterPd extends FlutterPdPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_pd/method');
  final eventChannel = const EventChannel('flutter_pd/event');

  /// identifier for [receive].
  int _receiveId = 0;

  /// Request a permission to access to microphone.
  @override
  Future<bool> checkPermission() async {
    return await methodChannel.invokeMethod<bool>('checkPermission') ?? false;
  }

  @override
  Future<void> startPd() {
    return methodChannel.invokeMethod('startPd');
  }

  @override
  Future<void> restartAudio(
    bool requestInput ) {
    return methodChannel.invokeMethod('startAudio', {
      'requireInput': requestInput,
      'restart': true,
    });
  }

  @override
  Future<void> stopPd() {
    return methodChannel.invokeMethod('stopPd');
  }

  @override
  Future<PdFileHandle> openAsset(String pdFileAssetPath) async {
    final handle = await methodChannel.invokeMethod<int>(
      'openAsset',
      pdFileAssetPath,
    );
    if (handle == null) {
      throw Exception('openAsset failed');
    }
    return PdFileHandle(
      handle: handle,
      pd: this,
    );
  }

  /// Should only be called from [PdFileHandle.close]. Do not call this directly.
  @override
  Future<void> close(int patchHandle) {
    return methodChannel.invokeMethod('close', patchHandle);
  }

  @override
  Future<void> startAudio({
    bool? requireInput,
  }) {
    return methodChannel.invokeMethod('startAudio', {
      'requireInput': requireInput,
    });
  }

  @override
  Future<void> send(String receiverName, double value) {
    return methodChannel.invokeMethod('send', {
      'receiver': receiverName,
      'value': value,
    });
  }

  @override
  Stream<PdEvent> receive(String symbol) {
    return eventChannel
        .receiveBroadcastStream({
          'symbol': symbol,
          'id': _receiveId++,
        })
        .map(PdEvent.fromNativeEvent)
        .where((e) => e != null)
        .cast();
  }
}
