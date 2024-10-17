import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import '../util/md_state_engine.dart';

abstract class MdWidgetState<TWidget extends StatefulWidget>
    extends MdState<TWidget> {
  List<MdStateObs> get observables;

  late final MdState? _mdState;

  @override
  void initState() {
    _mdState = context.findAncestorStateOfType<MdState>();
    _registerStateWatch();
    super.initState();
  }

  @override
  void reassemble() {
    _registerStateWatch();
    super.reassemble();
  }

  void _registerStateWatch() {
    MdStateEngine.I.register(this, observables, parentState: _mdState!);
  }

  @override
  void dispose() {
    MdStateEngine.I.removeByState(this);
    super.dispose();
  }
}
