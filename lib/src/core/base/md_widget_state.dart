import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import '../util/md_state_engine.dart';

abstract class MdWidgetState<TWidget extends StatefulWidget>
    extends MdState<TWidget> {
  List<Object?> get observables;

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

    MdStateEngine.I.register(this, () => observables, parentState: _mdState!);
  }

  @override
  void dispose() {
    MdStateEngine.I.removeByState(this);
    super.dispose();
  }
}
