import 'dart:async';

import 'package:flutter/material.dart';

class MdOnOff extends StatefulWidget {
  const MdOnOff({
    super.key,
    required this.enabled,
    required this.duration,
    required this.builder,
  });

  final bool enabled;
  final Duration duration;
  final Widget Function(bool status) builder;

  @override
  State<MdOnOff> createState() => _MdOnOffState();
}

class _MdOnOffState extends State<MdOnOff> {
  Timer? _timer;
  bool _status = true;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _timer = Timer.periodic(widget.duration, (timer) {
      if (mounted) {
        if (!widget.enabled && !_status) {
          setState(() {
            _status = true;
          });
        } else if (widget.enabled) {
          setState(() {
            _status = !_status;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_status);
  }
}
