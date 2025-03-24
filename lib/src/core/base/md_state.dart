import 'package:flutter/material.dart';

import '../i18n/fk_translate_processor.dart';

abstract class MdState<TWidget extends StatefulWidget> extends State<TWidget> {
  ThemeData get theme => Theme.of(context);

  @Deprecated(
      "Function deprecated due to code obfuscation issue. Please use Tr.<YOUR_TRANSLATION>. Denerated by dart run md_engine i18n")
  dynamic get tr => FkTranslatorProcessor(context);

  bool notifyView() {
    if (mounted) {
      setState(() {});
      return true;
    }
    return false;
  }
}
