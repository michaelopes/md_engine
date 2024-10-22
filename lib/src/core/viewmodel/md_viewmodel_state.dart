import 'package:flutter/widgets.dart';
import 'package:md_engine/src/core/helpers/load_object.dart';
import 'package:md_engine/src/core/util/md_view_error_event.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../base/md_state.dart';
import 'md_viewmodel.dart';

abstract class MdViewModelState<TWidget extends StatefulWidget,
    TVm extends MdViewModel> extends MdState<TWidget> {
  final TVm vm;

  MdViewModelState(this.vm);

  QParams get params => QR.params;

  MdViewErrorEvent? get onError => null;

  @override
  void reassemble() {
    vm.reassemble();
    super.reassemble();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  @protected
  @mustCallSuper
  void initState() {
    vm.setState(this);
    vm.setup();
    super.initState();
  }

  LoadObject loading(String key) => vm.getLoaderByKey(key);
}
