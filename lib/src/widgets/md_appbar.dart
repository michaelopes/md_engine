import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../core/base/md_stateless.dart';

class MdAppBar extends MdStateless implements PreferredSizeWidget {
  MdAppBar({
    super.key,
    this.icon,
    this.onBack,
    this.color,
    this.title,
    this.middle,
    this.titleStyle,
    this.centerTitle,
    this.padding = const EdgeInsets.only(top: 8, bottom: 8),
    this.actions = const [],
    this.elevation = 0.0,
    this.leadingType = MdAppBarLeadingType.back,
    this.leading,
    this.borderRadius,
    this.bgImage,
  });

  final MdAppBarLeadingType leadingType;
  final Widget? icon;
  final VoidCallback? onBack;
  final Color? color;
  final String? title;
  final Widget? leading;
  final Widget? middle;
  final TextStyle? titleStyle;
  final EdgeInsets padding;

  final bool? centerTitle;
  final double elevation;
  final List<Widget> actions;
  final BorderRadiusGeometry? borderRadius;
  final DecorationImage? bgImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Material(
        elevation: elevation,
        color: color ?? theme.appBarTheme.backgroundColor,
        child: Container(
          decoration: color != null ? null : BoxDecoration(image: bgImage),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: NavigationToolbar(
              centerMiddle:
                  centerTitle ?? (theme.appBarTheme.centerTitle ?? false),
              middleSpacing: 16.0,
              leading: _leading,
              middle: middle ??
                  Text(
                    title ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: titleStyle ?? theme.appBarTheme.toolbarTextStyle,
                  ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: actions,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 60);

  Widget get _leading {
    switch (leadingType) {
      case MdAppBarLeadingType.back:
        return _buildBackIcon;
      case MdAppBarLeadingType.close:
        return _buildCloseIcon;
      case MdAppBarLeadingType.none:
      default:
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: leading ?? const SizedBox(),
        );
    }
  }

  Widget get _buildBackIcon => UnconstrainedBox(
        child: GestureDetector(
          onTap: onBack ?? QR.back,
          child: Container(
            color: Colors.transparent,
            child: icon ??
                Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 8, top: 8),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 18,
                    color: theme.appBarTheme.iconTheme?.color,
                  ),
                ),
          ),
        ),
      );

  Widget get _buildCloseIcon => GestureDetector(
        onTap: onBack ?? QR.back,
        child: Container(
          height: 36,
          width: 36,
          margin: const EdgeInsets.only(left: 20, top: 4, bottom: 6),
          child: Icon(
            Icons.close,
            size: 24,
            color: theme.appBarTheme.iconTheme?.color,
          ),
        ),
      );
}

enum MdAppBarLeadingType { close, back, none }
