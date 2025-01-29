import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:md_engine/src/core/base/md_stateless.dart';

class MdSubtitle extends MdStateless {
  MdSubtitle({super.key, required this.text, this.opacity = .8});

  final String text;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(.8),
      ),
      minFontSize: 8,
    );
  }
}
