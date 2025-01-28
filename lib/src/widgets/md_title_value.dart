import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdTitleValue extends MdStateless {
  MdTitleValue({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AutoSizeText(
          value,
          minFontSize: 10,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color?.withOpacity(.7),
          ),
        ),
      ],
    );
  }
}
