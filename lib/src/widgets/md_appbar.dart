import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MdAppBar({
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
    this.type = MdAppBarType.original,
  });

  final MdAppBarType type;
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
  State<MdAppBar> createState() => _MdAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}

class _MdAppBarState extends MdState<MdAppBar> {
  Color? get bgColor => widget.color ?? theme.appBarTheme.backgroundColor;
  TextStyle? get titleStyle => (widget.titleStyle ??
      theme.appBarTheme.titleTextStyle ??
      theme.textTheme.headlineSmall?.copyWith(
        color: bgColor != null ? MdToolkit.I.getColorInverted(bgColor!) : null,
      ));

  bool get _isOriginal => MdAppBarType.original == widget.type;

  Widget get _title =>
      widget.middle ??
      Text(
        widget.title ?? "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: titleStyle,
      );

  Widget get _default {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Material(
        elevation: widget.elevation,
        color: bgColor,
        child: Container(
          color: bgColor,
          decoration: widget.bgImage != null
              ? BoxDecoration(image: widget.bgImage)
              : null,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: NavigationToolbar(
              centerMiddle: widget.centerTitle ??
                  (theme.appBarTheme.centerTitle ?? false),
              middleSpacing: 16.0,
              leading: _leading,
              middle: _title,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.actions,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _spaced {
    final padding = MediaQuery.paddingOf(context);
    const topPadding = 8.0;
    const size = 60 - topPadding - 2;
    return Column(
      children: [
        Container(
          height: padding.top,
          color: bgColor,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 2,
          ).copyWith(top: topPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: size,
                width: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(size / 2),
                ),
                child: SizedBox.expand(child: _leading),
              ),
              if (widget.actions.isNotEmpty)
                Container(
                  height: size,
                  //padding: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints(
                    minWidth: size,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(size / 2),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.actions,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isOriginal ? _default : _spaced;
  }

  Widget get _leading {
    switch (widget.leadingType) {
      case MdAppBarLeadingType.back:
        return _buildBackIcon;
      case MdAppBarLeadingType.close:
        return _buildCloseIcon;
      case MdAppBarLeadingType.none:
      default:
        return Padding(
          padding:
              _isOriginal ? const EdgeInsets.only(left: 16) : EdgeInsets.zero,
          child: widget.leading ?? const SizedBox(),
        );
    }
  }

  Widget get _buildBackIcon => UnconstrainedBox(
        child: GestureDetector(
          onTap: widget.onBack ?? QR.back,
          child: Container(
            color: Colors.transparent,
            child: widget.icon ??
                Padding(
                  padding: _isOriginal
                      ? const EdgeInsets.only(left: 14, bottom: 8, top: 8)
                      : EdgeInsets.zero,
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 18,
                    color: theme.appBarTheme.iconTheme?.color ??
                        (bgColor != null
                            ? MdToolkit.I.getColorInverted(bgColor!)
                            : null),
                  ),
                ),
          ),
        ),
      );

  Widget get _buildCloseIcon => GestureDetector(
        onTap: widget.onBack ?? QR.back,
        child: Container(
          height: 36,
          width: 36,
          margin: _isOriginal
              ? const EdgeInsets.only(left: 14, top: 4, bottom: 6)
              : EdgeInsets.zero,
          child: Icon(
            Icons.close,
            size: 24,
            color: theme.appBarTheme.iconTheme?.color ??
                (bgColor != null
                    ? MdToolkit.I.getColorInverted(bgColor!)
                    : null),
          ),
        ),
      );
}

enum MdAppBarLeadingType { close, back, none }

enum MdAppBarType { original, spacer }
