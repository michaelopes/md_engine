import 'package:flutter/material.dart';

class MdScreenUtility {
  MdScreenUtility._internal();

  static final MdScreenUtility I = MdScreenUtility._internal();

  late BuildContext context;

  void setContext(BuildContext context) {
    this.context = context;
  }

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}
