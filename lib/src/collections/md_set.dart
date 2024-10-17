import 'dart:collection';

import 'md_collection.dart';

class MdSet<T> with SetMixin<T> implements MdCollection {
  late final Set<T> _set;

  bool _hasChange = false;

  MdSet([Set<T>? set]) {
    if (set != null) {
      _set = set;
    } else {
      _set = {};
    }
  }

  static MdSet<T> of<T>(Set<T> set) => MdSet<T>(set);

  @override
  bool get hasChange {
    final result = _hasChange;
    _hasChange = false;
    return result;
  }

  void _makeChange() {
    _hasChange = true;
  }

  @override
  bool add(T value) {
    final result = _set.add(value);
    if (result) {
      _makeChange();
    }
    return result;
  }

  @override
  bool contains(Object? element) {
    return _set.contains(element);
  }

  @override
  Iterator<T> get iterator {
    return _set.iterator;
  }

  @override
  int get length {
    return _set.length;
  }

  @override
  T? lookup(Object? element) {
    return _set.lookup(element);
  }

  @override
  bool remove(Object? value) {
    final result = _set.remove(value);
    if (result) {
      _makeChange();
    }
    return result;
  }

  @override
  Set<T> toSet() {
    return this;
  }
}
