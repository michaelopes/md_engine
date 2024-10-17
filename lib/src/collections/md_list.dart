import 'dart:collection';
import 'dart:math';
import 'md_collection.dart';

class MdList<T> with ListMixin<T> implements MdCollection {
  late final List<T> _list;

  bool _hasChange = false;

  MdList([List<T>? list]) {
    if (list != null) {
      _list = list;
    } else {
      _list = [];
    }
  }

  @override
  int get length {
    return _list.length;
  }

  @override
  T get first {
    return _list.first;
  }

  @override
  T get last {
    return _list.last;
  }

  @override
  Iterable<T> get reversed {
    return _list.reversed;
  }

  @override
  bool get isEmpty {
    return _list.isEmpty;
  }

  @override
  bool get isNotEmpty {
    return _list.isNotEmpty;
  }

  @override
  Iterator<T> get iterator {
    return _list.iterator;
  }

  @override
  T get single {
    return _list.single;
  }

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
  Iterable<T> getRange(int start, int end) {
    return _list.getRange(start, end);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> newContents) {
    _list.replaceRange(start, end, newContents);
    _makeChange();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    _makeChange();
  }

  @override
  void fillRange(int start, int end, [T? fill]) {
    _list.fillRange(start, end, fill);
    _makeChange();
  }

  @override
  void add(T element) {
    _list.add(element);
    _makeChange();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    _makeChange();
  }

  @override
  bool remove(covariant T element) {
    final removed = _list.remove(element);
    if (removed) {
      _makeChange();
    }
    return removed;
  }

  @override
  T removeAt(int index) {
    final removed = _list.removeAt(index);
    _makeChange();
    return removed;
  }

  @override
  T removeLast() {
    final removed = _list.removeLast();
    _makeChange();
    return removed;
  }

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    _makeChange();
  }

  @override
  void removeWhere(bool Function(T) test) {
    _list.removeWhere(test);
    _makeChange();
  }

  @override
  void insert(int index, T element) {
    _list.insert(index, element);
    _makeChange();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _list.insertAll(index, iterable);
    _makeChange();
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _list.setAll(index, iterable);
    _makeChange();
  }

  @override
  void shuffle([Random? random]) {
    _list.shuffle(random);
    _makeChange();
  }

  @override
  void sort([int Function(T, T)? compare]) {
    _list.sort(compare);
    _makeChange();
  }

  @override
  List<T> sublist(int start, [int? end]) {
    return _list.sublist(start, end);
  }

  @override
  T singleWhere(bool Function(T) test, {T Function()? orElse}) {
    return _list.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    return _list.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T) test) {
    return _list.skipWhile(test);
  }

  @override
  void forEach(void Function(T) action) {
    _list.forEach(action);
  }

  @override
  void clear() {
    _list.clear();
    _makeChange();
  }

  static MdList<T> of<T>(List<T> list) => MdList<T>(list);

  @override
  List<T> operator +(List<T> other) {
    final newList = _list + other;

    return newList;
  }

  @override
  T operator [](int index) {
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
    _makeChange();
  }

  @override
  set length(int value) {
    _list.length = value;
    _makeChange();
  }
}
