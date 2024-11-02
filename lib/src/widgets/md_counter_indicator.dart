import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import '../core/util/md_typedefs.dart';

class MdCounterIndicator<T extends num> extends StatefulWidget {
  final T start;
  final T end;
  final Duration duration;
  final TextStyle? textStyle;
  final MdTextFormater? formater;

  const MdCounterIndicator({
    Key? key,
    required this.start,
    required this.end,
    this.textStyle,
    this.formater,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<MdCounterIndicator> createState() => _MdCounterIndicatorState<T>();
}

class _MdCounterIndicatorState<T extends num> extends State<MdCounterIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<T> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (T == int) {
      final an = IntTween(
        begin: widget.start as int,
        end: widget.end as int,
      ).animate(_controller)
        ..addListener(() {
          setState(() {});
        });
      _animation = an as Animation<T>;
    } else {
      final an = Tween(
        begin: widget.start as double,
        end: widget.end as double,
      ).animate(_controller)
        ..addListener(() {
          setState(() {});
        });
      _animation = an as Animation<T>;
    }
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = _animation.value;
    return AutoSizeText(
      widget.formater?.call(value) ?? '$value',
      style: widget.textStyle,
      maxLines: 1,
      minFontSize: 14,
    );
  }
}
