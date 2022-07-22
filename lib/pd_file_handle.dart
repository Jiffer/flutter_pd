import 'flutter_pd.dart';
import 'flutter_pd_method_channel.dart';

class PdFileHandle {
  int get handle => _handle;
  int _handle;
  // final FlutterPd _pd;
  final MethodChannelFlutterPd _pd;

  /// Do not call this directory.
  /// Use [FlutterPd.openAsset] to get [PdFileHandle].
  PdFileHandle({
    required int handle,
    required MethodChannelFlutterPd pd,
  })  : _handle = handle,
        _pd = pd;

  void close() {
    if (_handle != 0) {
      _pd.close(_handle);
      _handle = 0;
    }
  }
}
