import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import '../util/md_state_engine.dart';

typedef GlobalCondFunc = bool Function();

abstract class MdViewModel {
  late int _changeHashCode = _generateRandomHashCode();
  State? _state;
  ErrorObject? error;

  final _errorListeners = <VoidCallback>[];

  List<Object?> get observables;

  setState<T extends State>(T state) {
    _state = state;
    _registerStateWatch();
  }

  void reassemble() {
    _registerStateWatch();
  }

  void _registerStateWatch() {
    assert(
      observables.whereType<Function>().isEmpty,
      'Error on (${toString()}). **"Function" type is not suported to observables.**',
    );
    assert(
      observables.whereType<List>().isEmpty,
      'Error on (${toString()}). **"List" type is not suported to observables. Please use MdList.**',
    );
    assert(
      observables.whereType<List>().isEmpty,
      'Error on (${toString()}). **"Map" type is not suported to observables. Please use MdMap.**',
    );
    assert(
      observables.whereType<List>().isEmpty,
      'Error on (${toString()}). **"Set" type is not suported to observables. Please use MdSet.**',
    );
    MdStateEngine.I.register(
      getState(),
      () => [
        _changeHashCode,
        ...observables,
      ],
    );
  }

  T getState<T extends State>() => _state as T;

  final _controllerLoadings = [
    LoadObject.hideLoad(),
  ];

  bool get changeStateOnError => false;

  Future<void> setup();

  @mustCallSuper
  void dispose() {
    MdStateEngine.I.removeByState(getState());
    _controllerLoadings.clear();
  }

  int _generateRandomHashCode() {
    Random random = Random();
    int high = random.nextInt(1 << 16); // Parte alta
    int low = random.nextInt(1 << 16); // Parte baixa
    int combined = (high << 16) + low; // Combina as duas partes
    return combined;
  }

  void _updateHash() {
    _changeHashCode = _generateRandomHashCode();
  }

  void setLoading(bool status, {String key = "default"}) {
    var ld = _createOrGetLoaderByKey(key);
    ld.status = status;
  }

  ErrorListenerDisposer addErrorListener(VoidCallback listener) {
    _errorListeners.add(listener);
    return () {
      _errorListeners.remove(listener);
    };
  }

  LoadObject _createOrGetLoaderByKey(String key, {bool status = false}) {
    var filter = _controllerLoadings.where((e) => e.key == key);
    if (filter.isNotEmpty) {
      return filter.first;
    } else {
      var stl = LoadObject(
        key: key,
        status: status,
      );
      _controllerLoadings.add(stl);
      return stl;
    }
  }

  void setError(
    Object error,
    StackTrace stackTrace, {
    GlobalCondFunc? globalCallFilter,
  }) {
    for (var item in _controllerLoadings) {
      item.status = false;
    }
    this.error = ErrorObject(
      error: error,
      stackTrace: stackTrace,
    );
    for (var listener in _errorListeners) {
      listener();
    }
    if ((globalCallFilter?.call() ?? true)) {
      GlobalErrorObserver.dispatch(error, stackTrace);
    }
    if (changeStateOnError) {
      _updateHash();
    } else {
      this.error = null;
    }
  }

  void clearError() {
    error = null;
    if (changeStateOnError) {
      _updateHash();
    }
  }

  bool loading({String key = "default"}) => getLoaderByKey(key).status;

  LoadObject getLoaderByKey(String key) {
    return _createOrGetLoaderByKey(key);
  }
}
