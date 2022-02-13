import 'package:reactives/reactives.dart';

typedef ValueChanged<T> = void Function(T? oldValue, T newValue);

class ReactiveDouble extends ReactiveValue<double> {
  ReactiveDouble(
    ReactiveHost host, {
    double initial = 0,
    ValueChanged<double>? onChange,
    bool autoUpdate = true,
  }) : super(host, initial: initial, onChange: onChange, autoUpdate: autoUpdate);
}

class ReactiveInt extends ReactiveValue<int> {
  ReactiveInt(
    ReactiveHost host, {
    int initial = 0,
    ValueChanged<int>? onChange,
    bool autoUpdate = true,
  }) : super(host, initial: initial, onChange: onChange, autoUpdate: autoUpdate);
}

class ReactiveBool extends ReactiveValue<bool> {
  ReactiveBool(
    ReactiveHost host, {
    bool initial = false,
    ValueChanged<bool>? onChange,
    bool autoUpdate = true,
  }) : super(host, initial: initial, onChange: onChange, autoUpdate: autoUpdate);
}

class ReactiveString extends ReactiveValue<String> {
  ReactiveString(
    ReactiveHost host, {
    String initial = '',
    ValueChanged<String>? onChange,
    bool autoUpdate = true,
  }) : super(host, initial: initial, onChange: onChange, autoUpdate: autoUpdate);
}

class ReactiveValue<T> extends Reactive {
  ReactiveValue(ReactiveHost host, {required this.initial, this.onChange, this.autoUpdate = true}) : super(host) {
    _value = initial;
  }
  final T initial;
  late T _value;
  late T? _prev;
  final ValueChanged<T>? onChange;
  final bool autoUpdate;

  T get value => _value;
  set value(T value) {
    if (value == _value) return;
    _prev = _value;
    _value = value;
    onChange?.call(_prev, _value);
    // We can act _either_ as a ChangeNotifier or a `setState()` caller. This lets us encapsulate in a builder, or rebuild the entire state easily.
    if (autoUpdate) {
      host.requestUpdate();
    }
  }
}
