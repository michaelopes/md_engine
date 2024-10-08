import 'dart:math';

import 'package:flutter/material.dart';

class MdFlipTwoWidgets extends StatefulWidget {
  const MdFlipTwoWidgets({
    super.key,
    required this.front,
    required this.back,
  });

  final Widget front;
  final Widget back;

  @override
  State<MdFlipTwoWidgets> createState() => MdFlipTwoWidgetsState();
}

class MdFlipTwoWidgetsState extends State<MdFlipTwoWidgets> {
  late bool _showFrontSide;
  late bool _flipXAxis;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
    _flipXAxis = true;
  }

  void showFront() {
    setState(() {
      _showFrontSide = true;
    });
  }

  void showBack() {
    setState(() {
      _showFrontSide = false;
    });
  }

  Widget _buildFlipAnimation() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: __transitionBuilder,
      layoutBuilder: (widget, list) =>
          Stack(children: [widget ?? Container(), ...list]),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
      child: _showFrontSide ? widget.front : widget.back,
    );
  }

  Widget __transitionBuilder(Widget wdt, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: wdt,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != wdt.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          alignment: Alignment.center,
          child: wdt,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation();
  }
}
