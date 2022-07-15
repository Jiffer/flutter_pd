import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pd/flutter_pd.dart';
import 'package:flutter_pd/flutter_pd_platform_interface.dart';
import 'package:flutter_pd/flutter_pd_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPdPlatform 
    with MockPlatformInterfaceMixin
    implements FlutterPdPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPdPlatform initialPlatform = FlutterPdPlatform.instance;

  test('$MethodChannelFlutterPd is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPd>());
  });

  test('getPlatformVersion', () async {
    FlutterPd flutterPdPlugin = FlutterPd();
    MockFlutterPdPlatform fakePlatform = MockFlutterPdPlatform();
    FlutterPdPlatform.instance = fakePlatform;
  
    // expect(await flutterPdPlugin.getPlatformVersion(), '42');
  });
}
