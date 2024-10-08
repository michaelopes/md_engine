import 'package:flutter/material.dart';

class MdContainer extends StatelessWidget {
  const MdContainer({
    super.key,
    required this.child,
    this.bottom = 0,
    this.left = 14,
    this.right = 14,
    this.top = 0,
  });
  final Widget child;
  final double top;
  final double left;
  final double right;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: child,
    );
  }
}
