// import 'package:flutter/services.dart';
// import 'package:flutter_pd/flutter_pd.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   const MethodChannel channel = MethodChannel('flutter_pd/method');

//   TestWidgetsFlutterBinding.ensureInitialized();

//   late FlutterPd pd;

//   setUp(() {
//     pd = FlutterPd.private(
//       channel: channel,
//     );
//   });

//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });

//   test('checkPermission', () async {
//     final List<MethodCall> calls = [];
//     channel.setMockMethodCallHandler((MethodCall call) async {
//       calls.add(call);
//       return true;
//     });

//     expect(await pd.checkPermission(), true);
//     expect(calls.length, 1);
//     expect(calls[0].method, 'checkPermission');
//     expect(calls[0].arguments, isNull);
//   });

//   test('startPd', () async {
//     final List<MethodCall> calls = [];
//     channel.setMockMethodCallHandler((MethodCall call) async {
//       calls.add(call);
//       return 1;
//     });

//     await pd.startPd();

//     expect(calls.length, 1);
//     expect(calls[0].method, 'startPd');
//     expect(calls[0].arguments, isNull);
//   });

//   test('stopPd', () async {
//     final List<MethodCall> calls = [];
//     channel.setMockMethodCallHandler((MethodCall call) async {
//       calls.add(call);
//       return 1;
//     });

//     await pd.stopPd();

//     expect(calls.length, 1);
//     expect(calls[0].method, 'stopPd');
//     expect(calls[0].arguments, isNull);
//   });

//   test('openAsset', () async {
//     final List<MethodCall> calls = [];
//     channel.setMockMethodCallHandler((MethodCall call) async {
//       calls.add(call);
//       return 42;
//     });

//     final result = await pd.openAsset('assets/foo.pd');
//     expect(result.handle, 42);

//     expect(calls.length, 1);
//     expect(calls[0].method, 'openAsset');
//     expect(calls[0].arguments, 'assets/foo.pd');

//     result.close();
//     expect(result.handle, 0);

//     expect(calls.length, 2);
//     expect(calls[1].method, 'close');
//     expect(calls[1].arguments, 42); // returned handle from openAsset
//   });

//   test('startAudio', () async {
//     final List<MethodCall> calls = [];
//     channel.setMockMethodCallHandler((MethodCall call) async {
//       calls.add(call);
//     });

//     await pd.startAudio();

//     expect(calls.length, 1);
//     expect(calls[0].method, 'startAudio');
//     expect(calls[0].arguments, equals({'requireInput': null}));
//   });

//   test('startAudio with argument', () async {
//     final List<MethodCall> calls = [];
//     channel.setMockMethodCallHandler((MethodCall call) async {
//       calls.add(call);
//     });

//     await pd.startAudio(requireInput: false);

//     expect(calls.length, 1);
//     expect(calls[0].method, 'startAudio');
//     expect(calls[0].arguments, equals({'requireInput': false}));
//   });

//   test('send', () async {
//     final List<MethodCall> calls = [];
//     channel.setMockMethodCallHandler((MethodCall call) async {
//       calls.add(call);
//     });

//     await pd.send('foo', 1.0);

//     expect(calls.length, 1);
//     expect(calls[0].method, 'send');
//     expect(calls[0].arguments, equals({'receiver': 'foo', 'value': 1.0}));
//   });

//   test('receive', () async {
//     expect(pd.receive('foo'), isNotNull);
//   });
// }
