import 'dart:collection';
import 'md_collection.dart';

class MdMap<K, V> with MapMixin<K, V> implements MdCollection {
  late final Map<K, V> _map;
  bool _hasChange = false;

  MdMap([Map<K, V>? map]) {
    if (map != null) {
      _map = map;
    } else {
      _map = {};
    }
  }

  static MdMap<K, V> of<K, V>(Map<K, V> map) => MdMap<K, V>(map);

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
  void addAll(Map<K, V> other) {
    other.forEach((K key, V value) {
      _map[key] = value;
    });
    _makeChange();
  }

  @override
  V? operator [](Object? key) {
    return _map[key];
  }

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
    _makeChange();
  }

  @override
  void clear() {
    _map.clear();
    _makeChange();
  }

  @override
  Iterable<K> get keys {
    return _map.keys;
  }

  @override
  V? remove(Object? key) {
    final result = _map.remove(key);
    if (result != null) {
      _makeChange();
    }
    return result;
  }
}
