import 'dart:async';

import 'package:rx_notifier/rx_notifier.dart';

import 'md_toolkit.dart';

abstract class IMdGlobalTimer {
  void startTimer();
  int get timerCounter;
  String get timerCounterFormated;
}

class MdGlobalTimer implements IMdGlobalTimer {
  final _timerCounter = RxNotifier<int>(0);
  final _timerCounterFormated = RxNotifier<String>("0:00");

  @override
  int get timerCounter => _timerCounter.value;
  @override
  String get timerCounterFormated => _timerCounterFormated.value;

  @override
  void startTimer() {
    if (_timerCounter.value == 0) {
      _timerCounter.value = 60;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        _timerCounter.value = _timerCounter.value - 1;
        _timerCounterFormated.value = MdToolkit.I.durationToMinuteFormat(
          Duration(seconds: _timerCounter.value),
        );
        if (_timerCounter.value == 0) {
          timer.cancel();
        }
      });
    }
  }
}
