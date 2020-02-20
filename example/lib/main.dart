import 'package:flutter/material.dart';

import 'home_page.dart';
import 'microphone_meter.dart';
import 'simple_sin.dart';
import 'simple_sin_with_volume.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => HomePage(),
        '/simple_sin': (_) => SimpleSin(),
        '/simple_sin_with_volume': (_) => SimpleSinWithVolume(),
        '/microphone_meter': (_) => MicrophoneMeter(),
      },
    );
  }
}
