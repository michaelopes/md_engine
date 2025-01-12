import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import '../util/md_state_engine.dart';

abstract class MdWidgetState<TWidget extends StatefulWidget>
    extends MdState<TWidget> {
  List<MdStateObs> get observables => [];

  String _obsRegisterKey = "";

  @override
  void initState() {
    _registerStateWatch();
    super.initState();
  }

  @override
  void reassemble() {
    _registerStateWatch();
    super.reassemble();
  }

  void _registerStateWatch() {
    _obsRegisterKey = MdStateEngine.I.register(this, observables);
  }

  @override
  void dispose() {
    MdStateEngine.I.removeByKey(_obsRegisterKey);
    super.dispose();
  }
}
