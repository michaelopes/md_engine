import 'package:flutter/material.dart';

import '../../md_engine.dart';

enum MdButtonIconType { suffix, prefix }

class MdButton extends StatefulWidget {
  const MdButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.outline = false,
    this.style,
    this.inLoading = false,
    this.height,
    this.width,
    this.iconType = MdButtonIconType.prefix,
  });
  final void Function()? onPressed;
  final Widget? icon;
  final String text;
  final bool outline;
  final bool inLoading;
  final ButtonStyle? style;
  final double? height;
  final double? width;
  final MdButtonIconType iconType;
  @override
  State<MdButton> createState() => _MdButtonState();
}

class _MdButtonState extends MdState<MdButton> {
  Widget get _buildChild {
    var icon = widget.icon;
    if (icon != null && icon is MdIcn) {
      icon = icon.copyWith(color: indicatorColor);
    } else if (icon != null && icon is Icon) {
      icon = Icon(
        icon.icon,
        color: indicatorColor,
        size: icon.size,
      );
    }
    return widget.inLoading
        ? SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: indicatorColor,
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null && widget.iconType == MdButtonIconType.prefix)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: icon,
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  widget.text,
                ),
              ),
              if (icon != null && widget.iconType == MdButtonIconType.suffix)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: icon,
                ),
            ],
          );
  }

  Color? get indicatorColor {
    return theme.elevatedButtonTheme.style?.foregroundColor
        ?.resolve(<WidgetState>{WidgetState.pressed})?.withOpacity(1);
  }

  Widget get _buildElevated {
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.inLoading ? null : widget.onPressed,
      child: _buildChild,
    );
  }

  Widget get _buildOutline {
    return OutlinedButton(
      style: widget.style,
      onPressed: widget.inLoading ? null : widget.onPressed,
      child: _buildChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? kDefaultMdButtonHeight,
      width: widget.width ?? double.maxFinite,
      child: !widget.outline ? _buildElevated : _buildOutline,
    );
  }
}
