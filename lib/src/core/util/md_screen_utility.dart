import 'package:flutter/material.dart';
import 'package:md_engine/src/md_app.dart';

class MdScreenUtility {
  MdScreenUtility._internal();

  static final MdScreenUtility I = MdScreenUtility._internal();

  BuildContext get context => MdApp.context;

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}
