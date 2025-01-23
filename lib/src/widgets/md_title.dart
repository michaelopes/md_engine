import 'package:flutter/material.dart';

import '../core/base/md_stateless.dart';

class MdTitle extends MdStateless {
  MdTitle({
    super.key,
    required this.text,
    this.opacity = 1,
    this.style,
  });

  final String text;
  final double opacity;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(opacity),
          ) ??
          theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withOpacity(opacity),
          ),
    );
  }
}
