import 'dart:async';

class MdDebouncer<T> {
  MdDebouncer({
    required this.duration,
    required this.onValue,
  });

  final Duration duration;
  void Function(T? value) onValue;
  T? _value;
  Timer? _timer;
  T? get value => _value;
  set value(T? val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue(_value));
  }

  void cancel() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }
}
