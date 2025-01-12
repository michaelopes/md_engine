import 'package:flutter/scheduler.dart';
import 'package:md_engine/md_engine.dart';
import 'package:md_engine/src/collections/md_collection.dart';

final class MdStateObserver {
  late Object? snapshot;
  final Object? Function() checker;

  MdStateObserver({
    required this.checker,
  }) {
    snapshot = checker();
  }

  bool get hasChange {
    final newValue = checker();
    final result = snapshot != newValue;
    snapshot = newValue;
    return result;
  }
}

final class _MdStateEngineItem {
  final String key;
  final MdState state;
  final List<MdStateObserver> observables;

  _MdStateEngineItem({
    required this.key,
    required this.state,
    required this.observables,
  });

  bool get hasChange => observables.any((e) => e.hasChange);
}

final class MdStateEngine {
  MdStateEngine._internal();

  static final I = MdStateEngine._internal();
  final _storage = <_MdStateEngineItem>[];

  final _executeControl = _ChangeExecuteControl();

  Ticker? _ticker;

  String register(
    MdState state,
    List<MdStateObs> observables,
  ) {
    final index =
        _storage.indexWhere((e) => e.state.hashCode == state.hashCode);
    if (index >= 0) {
      _storage.removeAt(index);
    }
    final key = Uuid().v4();
    _storage.add(
      _MdStateEngineItem(
        key: key,
        observables: _processObservers(observables),
        state: state,
      ),
    );
    return key;
  }

  List<MdStateObserver> _processObservers(List<MdStateObs> observables) {
    final result = <MdStateObserver>[];
    for (var item in observables) {
      final value = item();
      if (value is MdStateObservable) {
        result.addAll(_processObservers(value.observables));
      } else if (value is MdCollection) {
        result.add(MdStateObserver(checker: () => value.hasChange));
      }
      result.add(MdStateObserver(checker: item));
    }
    return result;
  }

  void removeByKey(String key) {
    if (key.isEmpty) return;
    _storage.removeWhere((e) => e.key == key);
  }

  void start() {
    _ticker = Ticker(_onTick);
    if (!_ticker!.isActive) {
      _ticker!.start();
    }
  }

  void stop() {
    _ticker?.stop();
  }

  Iterable<_MdStateEngineItem> _getChangedItems() {
    return _storage.where((e) => e.hasChange);
  }

  void _onTick(Duration elapsedTime) {
    print("onTick");
    _executeControl.execute(() {
      final targets = _getChangedItems();
      for (var target in targets) {
        target.state.notifyView();
      }
    });
  }
}

class _ChangeExecuteControl {
  int _dControll = 0;

  int get _getTime {
    return DateTime.now().millisecondsSinceEpoch;
  }

  int get _getTimeDiff {
    return _getTime - _dControll;
  }

  void execute(void Function() runner) {
    if (_dControll == 0) {
      _dControll = _getTime;
      runner();
    } else if (_getTimeDiff >= 16) {
      _dControll = _getTime;
      runner();
    }
  }
}
