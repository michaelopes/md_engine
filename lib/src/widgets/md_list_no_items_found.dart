import 'package:flutter/material.dart';
import 'package:md_engine/src/core/base/md_stateless.dart';

import 'md_height.dart';

class MdListNoItemsFound extends MdStateless {
  MdListNoItemsFound({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.showIcon = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.showTitle = true,
  });
  final Widget? icon;
  final String? title;
  final String? message;
  final MainAxisAlignment mainAxisAlignment;
  final bool showIcon;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (showIcon) ...[
          SizedBox(
            child: icon,
          ),
          const MdHeight(26),
        ],
        if (showTitle) ...[
          Text(
            title ?? tr.no_items_found.title(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const MdHeight(12),
        ],
        SizedBox(
          width: 300,
          child: Text(
            message ?? tr.no_items_found.message(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        const MdHeight(60)
      ],
    );
  }
}
