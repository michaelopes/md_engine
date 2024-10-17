import 'package:flutter/material.dart';

typedef WidgetBuilderArgs = Widget Function(
  Map<String, List<String>> params,
  dynamic args,
);

typedef ErrorListenerDisposer = void Function();

typedef MdStateObs = Object? Function();
