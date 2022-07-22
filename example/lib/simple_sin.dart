import 'package:flutter/material.dart';
import 'package:flutter_pd/flutter_pd.dart';

class SimpleSin extends StatefulWidget {
  @override
  _SimpleSinState createState() => _SimpleSinState();
}

class _SimpleSinState extends State<SimpleSin> {
  final _pd = FlutterPd.instance;
  PdFileHandle _pdFileHandle;

  final _assetPath = 'assets/simple_sin.pd';

  @override
  void initState() {
    super.initState();
    _setupPd();
  }

  @override
  void dispose() {
    _pdFileHandle?.close();
    _pd.stopPd();
    super.dispose();
  }

  Future<bool> _setupPd() async {
    // this step can be skipped because simple_sin.pd does not require audio input.
    // final hasPermission = await pd.checkPermission();
    // if (!hasPermission) {
    //   return false;
    // }

    await _pd.startPd();

    _pdFileHandle = await _pd.openAsset(_assetPath);

    await _pd.startAudio(
      requireInput: false,
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple sin'),
      ),
      body: Center(
        child: Text('Playing $_assetPath'),
      ),
    );
  }
}
