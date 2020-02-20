import 'package:flutter/foundation.dart';

import '../flutter_pd.dart';
import 'flutter_pd.dart';

class PdFileHandle {
  int get handle => _handle;
  int _handle;
  final FlutterPd _pd;

  /// Do not call this directory.
  /// Use [FlutterPd.openAsset] to get [PdFileHandle].
  PdFileHandle({
    @required int handle,
    @required FlutterPd pd,
  })  : assert(handle != null),
        assert(pd != null),
        _handle = handle,
        _pd = pd;

  void close() {
    if (_handle != 0) {
      _pd.close(_handle);
      _handle = 0;
    }
  }
}
