import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Pd demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: _open('/simple_sin'),
            title: Text('Simple demo'),
            subtitle: Text('Be careful with the sound volume of device.'),
          ),
          ListTile(
            onTap: _open('/simple_sin_with_volume'),
            title: Text('Send value from flutter'),
            subtitle: Text('Demonstrates how to send value from flutter.'),
          ),
          ListTile(
            onTap: _open('/microphone_meter'),
            title: Text('Microphone meter'),
            subtitle: Text('Demonstrates how to receive value from Pd.'),
          ),
        ],
      ),
    );
  }

  VoidCallback _open(String routeName) {
    return () {
      Navigator.pushNamed(context, routeName);
    };
  }
}
