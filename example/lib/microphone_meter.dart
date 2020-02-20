import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pd/flutter_pd.dart';

class MicrophoneMeter extends StatefulWidget {
  @override
  _MicrophoneMeterState createState() => _MicrophoneMeterState();
}

class _MicrophoneMeterState extends State<MicrophoneMeter> {
  final _pd = FlutterPd.instance;
  PdFileHandle _pdFileHandle;

  final _assetPath = 'assets/microphone_level.pd';

  Stream<FloatEvent> _pdEvent;

  @override
  void initState() {
    super.initState();
    _pdEvent = _receivePdEvent();
  }

  @override
  void dispose() {
    _pdFileHandle?.close();
    _pd.stopPd();
    super.dispose();
  }

  /// Prepare pd and setup Stream from pd.
  Stream<FloatEvent> _receivePdEvent() async* {
    final hasPermission = await _pd.checkPermission();
    if (!hasPermission) {
      return;
    }

    await _pd.startPd();

    _pdFileHandle = await _pd.openAsset(_assetPath);

    await _pd.startAudio(
      requireInput: true,
    );

    yield* _pd.receive('micVolume').where((it) => it is FloatEvent).cast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Microphone meter'),
      ),
      body: Center(
        child: StreamBuilder<FloatEvent>(
          stream: _pdEvent,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final event = snapshot.data;
              return Text('Microphone level: ${event.value}db');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('Preparing $_assetPath');
            }
          },
        ),
      ),
    );
  }
}
