import 'package:flutter/material.dart';

import '../i18n/fk_translate_processor.dart';

abstract class MdState<TWidget extends StatefulWidget> extends State<TWidget> {
  ThemeData get theme => Theme.of(context);
  dynamic get tr => FkTranslatorProcessor(context);

  bool notifyView() {
    if (mounted) {
      setState(() {});
      return true;
    }
    return false;
  }
}
