import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pd/flutter_pd.dart';
import 'package:flutter_pd/pd_file_handle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterPdPlugin = FlutterPd();
  PdFileHandle? _pdFileHandle; // todo: make non-nullable?
  final _assetPath = 'assets/simple_sin_with_volume.pd';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    await _flutterPdPlugin.startPd();

    _pdFileHandle = await _flutterPdPlugin.openAsset(_assetPath);

    await _flutterPdPlugin.startAudio(
      requireInput: false,
    );

    return;
  }

  double sliderVal = 0.5;
  void onChanged(double newVal){
    _flutterPdPlugin.send("volume", newVal);
    setState(() {
      sliderVal = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Slider(min: 0, max: 1, value: sliderVal, onChanged: onChanged)
            ],
          ),
        ),
      ),
    );
  }
}
