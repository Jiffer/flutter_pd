import 'package:flutter/material.dart';
import 'package:flutter_pd/flutter_pd.dart';

class SimpleSinWithVolume extends StatefulWidget {
  @override
  _SimpleSinWithVolumeState createState() => _SimpleSinWithVolumeState();
}

class _SimpleSinWithVolumeState extends State<SimpleSinWithVolume> {
  final _pd = FlutterPd.instance;
  PdFileHandle _pdFileHandle;

  final _assetPath = 'assets/simple_sin_with_volume.pd';
  double _volume = 0.0;

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
    // this step can be skipped because simple_sin_with_volume.pd does not require audio input.
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
        title: Text('Send value from flutter demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Volume:'),
              Slider(
                onChanged: _changeVolume,
                value: _volume,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeVolume(double newValue) {
    _pd.send('volume', newValue);
    setState(() {
      _volume = newValue;
    });
  }
}
