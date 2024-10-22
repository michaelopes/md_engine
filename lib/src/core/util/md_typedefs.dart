import 'package:flutter/material.dart';

typedef WidgetBuilderArgs = Widget Function(
  Map<String, List<String>> params,
  dynamic args,
);

typedef ErrorListenerDisposer = void Function();

typedef MdStateObs = Object? Function();

typedef ErrorStateObsListener = Future<void> Function(
  Object state,
  StackTrace stackTrace,
  ErrorOnBackCallback? onBack,
);
typedef ErrorOnShowCallback = Future<bool> Function(
  Object error,
  StackTrace stackTrace,
);
typedef ErrorOnBackCallback = void Function(Object error);
