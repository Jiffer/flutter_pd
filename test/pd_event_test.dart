import 'package:flutter_pd/flutter_pd.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('FloatEvent', () {
    final event = PdEvent.fromNativeEvent({
      'type': 'float',
      'from': 'foo',
      'value': 42.0,
    });

    expect(event, isInstanceOf<FloatEvent>());

    final FloatEvent floatEvent = event;
    expect(floatEvent.from, 'foo');
    expect(floatEvent.value, 42);
  });

  test('BangEvent', () {
    final event = PdEvent.fromNativeEvent({
      'type': 'bang',
      'from': 'foo',
    });

    expect(event, isInstanceOf<BangEvent>());

    final BangEvent bangEvent = event;
    expect(bangEvent.from, 'foo');
  });

  test('SymbolEvent', () {
    final event = PdEvent.fromNativeEvent({
      'type': 'symbol',
      'from': 'foo',
      'value': 'bar',
    });

    expect(event, isInstanceOf<SymbolEvent>());

    final SymbolEvent symbolEvent = event;
    expect(symbolEvent.from, 'foo');
    expect(symbolEvent.symbol, 'bar');
  });

  test('ListEvent', () {
    final event = PdEvent.fromNativeEvent({
      'type': 'list',
      'from': 'foo',
      'value': [42, 'bar'],
    });

    expect(event, isInstanceOf<ListEvent>());

    final ListEvent listEvent = event;
    expect(listEvent.from, 'foo');
    expect(listEvent.data, equals([42, 'bar']));
  });

  test('MessageEvent', () {
    final event = PdEvent.fromNativeEvent({
      'type': 'message',
      'from': 'foo',
      'symbol': 'bar',
      'args': [42, 'baz'],
    });

    expect(event, isInstanceOf<MessageEvent>());

    final MessageEvent messageEvent = event;
    expect(messageEvent.from, 'foo');
    expect(messageEvent.symbol, 'bar');
    expect(messageEvent.args, equals([42, 'baz']));
  });
}
