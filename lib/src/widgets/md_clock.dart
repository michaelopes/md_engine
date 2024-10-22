import 'dart:async';

import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdClock extends StatefulWidget {
  const MdClock({super.key, this.textStyle});

  final TextStyle? textStyle;

  @override
  State<MdClock> createState() => _MdClockState();
}

class _MdClockState extends MdWidgetState<MdClock> {
  DateTime _currentDateTime = DateTime.now();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentDateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Formata a data e a hora
    String formattedDateTime =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(_currentDateTime);

    return Text(
      formattedDateTime,
      style: widget.textStyle ?? theme.textTheme.bodyMedium,
    );
  }

  @override
  List<MdStateObs> get observables => [
        () => _currentDateTime.millisecondsSinceEpoch,
      ];
}
