import 'package:flutter/scheduler.dart';
import 'package:md_engine/md_engine.dart';
import 'package:collection/collection.dart';
import 'package:md_engine/src/collections/md_collection.dart';

final class _MdStateEngineItem {
  final MdState state;
  final MdState? parentState;
  final List<Object?> Function() observables;
  List<Object?> observablesSnapshot = [];

  final List<_MdStateEngineItem> childStateEngineItems = [];

  _MdStateEngineItem({
    required this.state,
    required this.observables,
    this.parentState,
  }) {
    snapshot();
  }

  void snapshot() {
    observablesSnapshot = _getCurrentObservables;
  }

  List<Object?> get _getCurrentObservables {
    return _getCurrentObservablesRecursive(observables(), []);
  }

  List<Object?> _getCurrentObservablesRecursive(
      List<Object?> observables, List<Object?> accumulator) {
    if (observables.isEmpty) {
      return accumulator;
    }
    var first = observables.first;
    var remaining = observables.sublist(1);

    if (first is MdStateObservable) {
      return _getCurrentObservablesRecursive(
        remaining,
        accumulator..addAll(first.observables),
      );
    } else {
      return _getCurrentObservablesRecursive(
        remaining,
        accumulator..add(first),
      );
    }
  }

  bool get hasChange => compareLists(
        observablesSnapshot,
        _getCurrentObservables,
      );

  bool compareLists(List<Object?> list1, List<Object?> list2) {
    if (list1.length != list2.length) {
      return true;
    }
    bool result = !IterableZip([list1, list2]).every((e) {
      final v1 = e[0];
      final v2 = e[1];
      if (v2 is MdCollection) {
        final r = v2.hasChange;
        if (r) {
          v2.observed();
        }
        return !r;
      }
      return v1 == v2;
    });
    return result;
  }
}

final class MdStateEngine {
  MdStateEngine._internal();

  static final I = MdStateEngine._internal();
  final _storage = <_MdStateEngineItem>[];

  Ticker? _ticker;

  void register(
    MdState state,
    List<Object?> Function() observables, {
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
          observables: observables,
          state: state,
          parentState: parentItem?.parentState ?? parentState,
        ),
      );
    } else {
      _storage.insert(
        index,
        _MdStateEngineItem(
          observables: observables,
          state: state,
          parentState: parentItem?.parentState ?? parentState,
        ),
      );
    }
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
        if (target.state.notifyView()) {
          target.snapshot();
        }
      } else {
        final items = _storage.where(
          (e) =>
              e.parentState != null &&
              e.parentState.hashCode == target.state.hashCode,
        );
        if (items.isNotEmpty) {
          final item = _checkAndGetChangedChildStateItem(items);
          if (item != null) {
            if (item.state.notifyView()) {
              item.snapshot();
            }
          }
        }
      }
    }
  }
}
