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
    if (_value == val) return;
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () {
      onValue(_value);
      _value = null;
    });
  }

  void cancel() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }
}
