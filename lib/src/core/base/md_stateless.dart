import 'package:flutter/material.dart';

import '../i18n/fk_translate_processor.dart';

abstract class MdStateless extends Widget {
  MdStateless({super.key});
  final _contextMemStore = _ContextMemStore();
  dynamic get tr => FkTranslatorProcessor(context);

  void _refreshContext(context) {
    _contextMemStore.context = context;
  }

  @override
  MdWidgetElement createElement() => MdWidgetElement(
        this,
      );

  BuildContext get context => _contextMemStore.context;
  ThemeData get theme => Theme.of(context);

  Widget build(BuildContext context);
}

final class _ContextMemStore {
  late BuildContext context;
}

final class MdWidgetElement extends ComponentElement {
  MdWidgetElement(MdStateless super.widget);

  MdStateless get _widget => (widget as MdStateless);

  @override
  void reassemble() {
    _widget._refreshContext(this);
    super.reassemble();
  }

  @override
  void update(MdStateless newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild(force: true);
  }

  @override
  Widget build() {
    _widget._refreshContext(this);
    return _widget.build(this);
  }
}
