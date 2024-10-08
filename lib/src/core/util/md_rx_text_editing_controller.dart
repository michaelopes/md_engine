import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class MdRxTextEditingController extends TextEditingController {
  MdRxTextEditingController({super.text}) {
    _rx = RxNotifier<String>(super.text);
    super.addListener(() {
      _rx.value = super.text;
    });
  }

  @override
  String get text => _rx.value;

  late final RxNotifier<String> _rx;
}
