abstract class PdEvent {
  final String from;

  const PdEvent(this.from);

  static PdEvent? fromNativeEvent(dynamic event) {
    if (event is! Map) {
      return null;
    }

    final String type = event['type'];
    final String from = event['from'];
    switch (type) {
      case 'float':
        return FloatEvent(from, event['value']);
      case 'bang':
        return BangEvent(from);
      case 'symbol':
        return SymbolEvent(from, event['value']);
      case 'list':
        return ListEvent(from, event['value']);
      case 'message':
        return MessageEvent(from, event['symbol'], event['args']);
      default:
        return null;
    }
  }
}

class BangEvent extends PdEvent {
  const BangEvent(String from) : super(from);
}

class FloatEvent extends PdEvent {
  final double value;

  const FloatEvent(String from, this.value) : super(from);
}

class SymbolEvent extends PdEvent {
  final String symbol;

  const SymbolEvent(String from, this.symbol) : super(from);
}

class ListEvent extends PdEvent {
  final List data;

  const ListEvent(String from, this.data) : super(from);
}

class MessageEvent extends PdEvent {
  final String symbol;
  final List args;

  const MessageEvent(String from, this.symbol, this.args) : super(from);
}
