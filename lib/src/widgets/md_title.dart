import 'package:flutter/material.dart';

import '../core/base/md_stateless.dart';

class MdTitle extends MdStateless {
  MdTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
