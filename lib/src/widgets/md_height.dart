import 'package:flutter/cupertino.dart';

class MdHeight extends StatelessWidget {
  const MdHeight(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: value,
    );
  }
}
