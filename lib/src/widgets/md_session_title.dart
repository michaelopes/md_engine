import 'package:flutter/material.dart';
import 'package:md_engine/src/core/base/md_stateless.dart';

class MdSessionTitle extends MdStateless {
  MdSessionTitle({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700, color: theme.colorScheme.onBackground),
    );
  }
}
