import 'dart:async';
import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdTimerBar extends StatefulWidget {
  const MdTimerBar({
    super.key,
    required this.expire,
    this.onExpire,
  });
  final Duration expire;
  final VoidCallback? onExpire;

  @override
  State<MdTimerBar> createState() => _MdTimerBarState();
}

class _MdTimerBarState extends MdState<MdTimerBar> {
  int _decrement = 0;

  late final Timer _timer;

  @override
  void initState() {
    _decrement = widget.expire.inSeconds;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _decrement = _decrement - 1;
      });

      if (_decrement <= 0) {
        timer.cancel();
        widget.onExpire?.call();
      }
    });
    super.initState();
  }

  double get _percent {
    return ((_decrement * 100) / widget.expire.inSeconds) / 100;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: _percent,
        ),
        MdHeight(4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "0:00",
              style: theme.textTheme.labelSmall,
            ),
            Text(
              MdToolkit.I.formatDuration(
                Duration(seconds: _decrement),
              ),
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}
