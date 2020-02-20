abstract class PdEvent {
  static PdEvent fromNativeEvent(event) {
    if (event is! Map) {
      return null;
    }

    final type = event['type'];
    switch (type) {
      case 'float':
        return FloatEvent(event['value']);
      default:
        return null;
    }
  }
}

class BangEvent extends PdEvent {}

class FloatEvent extends PdEvent {
  final double value;

  FloatEvent(this.value);
}

class SymbolEvent extends PdEvent {
  final String symbol;

  SymbolEvent(this.symbol);
}

class ListEvent extends PdEvent {
  final List data;

  ListEvent(this.data);
}

class MessageEvent extends PdEvent {
  final String message;

  MessageEvent(this.message);
}
