import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../flutter_pd.dart';
import 'pd_event.dart';
import 'pd_file_handle.dart';

class FlutterPd {
  @visibleForTesting
  FlutterPd.private({
    this.channel = const MethodChannel('flutter_pd/method'),
    this.eventChannel = const EventChannel('flutter_pd/event'),
  });

  static FlutterPd instance = FlutterPd.private();

  final MethodChannel channel;
  final EventChannel eventChannel;

  /// identifier for [receive].
  int _receiveId = 0;

  /// Request a permission to access to microphone.
  Future<bool> checkPermission() {
    return channel.invokeMethod('checkPermission');
  }

  Future<void> startPd() {
    return channel.invokeMethod('startPd');
  }

  Future<void> stopPd() {
    return channel.invokeMethod('stopPd');
  }

  Future<PdFileHandle> openAsset(String pdFileAssetPath) async {
    final handle = await channel.invokeMethod('openAsset', pdFileAssetPath);
    return PdFileHandle(
      handle: handle,
      pd: this,
    );
  }

  /// Should only be called from [PdFileHandle.close]. Do not call this directly.
  Future<void> close(int patchHandle) {
    return channel.invokeMethod('close', patchHandle);
  }

  Future<void> startAudio({
    bool requireInput,
  }) {
    return channel.invokeMethod('startAudio', {
      'requireInput': requireInput,
    });
  }

  Future<void> send(String receiverName, double value) {
    return channel.invokeMethod('send', {
      'receiver': receiverName,
      'value': value,
    });
  }

  Stream<PdEvent> receive(String symbol) {
    return eventChannel.receiveBroadcastStream({
      'symbol': symbol,
      'id': _receiveId++,
    }).map(PdEvent.fromNativeEvent);
  }
}
