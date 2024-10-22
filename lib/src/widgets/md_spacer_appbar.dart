import 'package:flutter/widgets.dart';
import 'package:md_engine/md_engine.dart';

import 'md_appbar.dart';

class MdSpacerAppBar extends StatefulWidget {
  const MdSpacerAppBar({
    super.key,
    this.icon,
    this.onBack,
    this.color,
    this.title,
    this.middle,
    this.titleStyle,
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

  final double elevation;
  final List<Widget> actions;
  final BorderRadiusGeometry? borderRadius;
  final DecorationImage? bgImage;

  @override
  State<MdSpacerAppBar> createState() => _MdSpacerAppBarState();
}

class _MdSpacerAppBarState extends MdState<MdSpacerAppBar> {
  Color? get bgColor => widget.color ?? theme.appBarTheme.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
