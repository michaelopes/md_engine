import 'package:flutter/material.dart';

class MdWidth extends StatelessWidget {
  const MdWidth(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: value,
    );
  }
}
