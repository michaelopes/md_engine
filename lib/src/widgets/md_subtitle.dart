import 'package:flutter/material.dart';
import 'package:md_engine/src/core/base/md_stateless.dart';

class MdSubtitle extends MdStateless {
  MdSubtitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
