import 'flutter_pd_platform_interface.dart';
import 'pd_event.dart';
import 'pd_file_handle.dart';

export 'pd_event.dart';
export 'pd_file_handle.dart';

class FlutterPd {
  FlutterPd._();
  static final FlutterPd instance = FlutterPd._();
  /// Request a permission to access to microphone.
  Future<bool> checkPermission() async {
    return FlutterPdPlatform.instance.checkPermission();
  }

  Future<void> startPd() {
    return FlutterPdPlatform.instance.startPd();
  }

  Future<void> restartAudio(bool requestInput){
    return FlutterPdPlatform.instance.restartAudio(requestInput);
  }

  Future<void> stopPd() {
    return FlutterPdPlatform.instance.stopPd();
  }

  Future<PdFileHandle> openAsset(String pdFileAssetPath) async {
    return FlutterPdPlatform.instance.openAsset(pdFileAssetPath);
  }

  /// Should only be called from [PdFileHandle.close]. Do not call this directly.
  Future<void> close(int patchHandle) {
    return FlutterPdPlatform.instance.close(patchHandle);
  }

  Future<void> startAudio({
    bool? requireInput,
  }) {
    return FlutterPdPlatform.instance.startAudio(requireInput: requireInput);
  }

  Future<void> send(String receiverName, double value) {
    return FlutterPdPlatform.instance.send(receiverName, value);
  }

  Stream<PdEvent> receive(String symbol) {
    return FlutterPdPlatform.instance.receive(symbol);
  }
}
