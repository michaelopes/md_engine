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

  List<MdStateObs> get observables;

  String _obsRegisterKey = "";

  setState<T extends State>(T state) {
    _state = state;
    _registerStateWatch();
  }

  void reassemble() {
    _registerStateWatch();
  }

  void _registerStateWatch() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _obsRegisterKey = MdStateEngine.I.register(
        getState(),
        [
          () {
            return _changeHashCode;
          },
          ...observables,
        ],
      );
    });
  }

  T getState<T>() => _state as T;

  final _controllerLoadings = [
    LoadObject.hideLoad(),
  ];

  bool get changeStateOnError => false;

  Future<void> setup();

  @mustCallSuper
  void dispose() {
    MdStateEngine.I.removeByKey(_obsRegisterKey);
    _controllerLoadings.clear();
  }

  int _generateRandomHashCode() {
    Random random = Random();
    int high = random.nextInt(1 << 16);
    int low = random.nextInt(1 << 16);
    int combined = (high << 16) + low;
    return combined;
  }

  void _updateHash() {
    _changeHashCode = _generateRandomHashCode();
  }

  void setLoading(bool status, {String key = "default"}) {
    var ld = _createOrGetLoaderByKey(key);
    ld.status = status;
    _updateHash();
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

  void setError(Object error, StackTrace stackTrace) {
    for (var item in _controllerLoadings) {
      item.status = false;
    }
    this.error = ErrorObject(
      error: error,
      stackTrace: stackTrace,
    );

    final state = getState();

    MdViewErrorEvent? onError;
    if (state is MdViewModelState) {
      onError = state.onError;
    }
    GlobalErrorObserver.dispatch(error, stackTrace, onError);
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
