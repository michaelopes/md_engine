import 'package:flutter/material.dart';

abstract class MdState<TWidget extends StatefulWidget> extends State<TWidget> {
  ThemeData get theme => Theme.of(context);

  bool notifyView() {
    if (mounted) {
      setState(() {});
      return true;
    }
    return false;
  }
}
