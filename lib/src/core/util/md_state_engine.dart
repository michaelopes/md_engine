import 'package:flutter/scheduler.dart';
import 'package:md_engine/md_engine.dart';
import 'package:collection/collection.dart';
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
    final result = snapshot != checker();
    snapshot = checker();
    return result;
  }
}

final class _MdStateEngineItem {
  final MdState state;
  final MdState? parentState;
  final List<MdStateObserver> observables;

  _MdStateEngineItem({
    required this.state,
    required this.observables,
    this.parentState,
  });

  bool get hasChange => observables.any((e) => e.hasChange);
}

final class MdStateEngine {
  MdStateEngine._internal();

  static final I = MdStateEngine._internal();
  final _storage = <_MdStateEngineItem>[];

  Ticker? _ticker;

  void register(
    MdState state,
    List<MdStateObs> observables, {
    MdState? parentState,
  }) {
    final index =
        _storage.indexWhere((e) => e.state.hashCode == state.hashCode);
    if (index >= 0) {
      _storage.removeAt(index);
    }
    final parentItem = parentState == null
        ? null
        : _storage
            .firstWhereOrNull((e) => e.state.hashCode == parentState.hashCode);
    if (index == -1) {
      _storage.add(
        _MdStateEngineItem(
          observables: _processObservers(observables),
          state: state,
          parentState: parentItem?.parentState ?? parentState,
        ),
      );
    } else {
      _storage.insert(
        index,
        _MdStateEngineItem(
          observables: _processObservers(observables),
          state: state,
          parentState: parentItem?.parentState ?? parentState,
        ),
      );
    }
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

  void removeByState(MdState state) {
    _storage.removeWhere((e) => e.state.hashCode == state.hashCode);
  }

  _MdStateEngineItem? get _targetObserver {
    if (_storage.isEmpty) return null;
    return _storage.where((e) => e.parentState == null).last;
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

  _MdStateEngineItem? _checkAndGetChangedChildStateItem(
      Iterable<_MdStateEngineItem> items,
      {int index = 0}) {
    if (items.isEmpty) return null;
    if (items.elementAt(index).hasChange) {
      return items.elementAt(index);
    }
    final newIndex = index + 1;
    if (items.length - 1 >= newIndex) {
      return _checkAndGetChangedChildStateItem(items, index: newIndex);
    }
    return null;
  }

  void _onTick(Duration elapsedTime) {
    final target = _targetObserver;
    if (target != null) {
      if (target.hasChange) {
        target.state.notifyView();
      } else {
        final items = _storage.where(
          (e) =>
              e.parentState != null &&
              e.parentState.hashCode == target.state.hashCode,
        );
        if (items.isNotEmpty) {
          final item = _checkAndGetChangedChildStateItem(items);
          if (item != null) {
            item.state.notifyView();
          }
        }
      }
    }
  }
}
