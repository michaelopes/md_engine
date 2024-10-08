import 'package:flutter/material.dart';

import 'package:md_engine/src/core/base/md_stateless.dart';

import '../core/util/md_toolkit.dart';

class MdCommonTag extends MdStateless {
  MdCommonTag({
    super.key,
    required this.text,
    this.color,
    this.isLarge = false,
  });

  final String text;
  final bool isLarge;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        height: isLarge ? 40 : 20,
        padding: EdgeInsets.symmetric(horizontal: isLarge ? 16 : 10),
        margin: EdgeInsets.only(right: isLarge ? 8 : 4, top: 2, bottom: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(isLarge ? 20 : 10),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: MdToolkit.I.getColorInverted(color!),
              fontSize: isLarge ? 16 : 11,
            ),
          ),
        ),
      ),
    );
  }
}
