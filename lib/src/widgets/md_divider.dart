import 'package:flutter/material.dart';

import '../core/base/md_stateless.dart';

class MdDivider extends MdStateless {
  MdDivider({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .5,
      width: double.infinity,
      color: color ?? theme.dividerColor,
    );
  }
}
