import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdObserver extends StatefulWidget {
  const MdObserver({
    super.key,
    required this.observables,
    required this.builder,
  });

  final List<MdStateObs> observables;
  final WidgetBuilder builder;

  @override
  State<MdObserver> createState() => _MdObserverState();
}

class _MdObserverState extends MdWidgetState<MdObserver> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  List<MdStateObs> get observables => widget.observables;
}
