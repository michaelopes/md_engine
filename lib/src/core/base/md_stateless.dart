import 'package:flutter/material.dart';

import '../i18n/fk_translate_processor.dart';

abstract class MdStateless extends Widget {
  MdStateless({Key? key}) : super(key: key);
  final __contextMemStore = _ContextMemStore();
  dynamic get tr => FkTranslatorProcessor(context);

  @override
  MdWidgetElement createElement() => MdWidgetElement(
        this,
        refreshContext: (context) {
          __contextMemStore.context = context;
        },
      );

  BuildContext get context => __contextMemStore.context;
  ThemeData get theme => Theme.of(context);

  Widget build(BuildContext context);
}

final class _ContextMemStore {
  late BuildContext context;
}

final class MdWidgetElement extends ComponentElement {
  MdWidgetElement(
    MdStateless super.widget, {
    required this.refreshContext,
  });

  final void Function(BuildContext context) refreshContext;

  MdStateless get _widget => (widget as MdStateless);

  @override
  Widget build() {
    refreshContext(this);
    return _widget.build(this);
  }

  @override
  void update(MdStateless newWidget) {
    refreshContext(this);
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild(force: true);
  }
}
