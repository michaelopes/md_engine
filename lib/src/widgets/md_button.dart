import 'package:flutter/material.dart';

import '../core/base/md_state.dart';
import 'md_icon.dart';

class MdButton extends StatefulWidget {
  const MdButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.outline = false,
    this.style,
    this.inLoading = false,
    this.height = 46,
    this.width,
  });
  final void Function()? onPressed;
  final Widget? icon;
  final String text;
  final bool outline;
  final bool inLoading;
  final ButtonStyle? style;
  final double height;
  final double? width;
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
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: icon,
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  widget.text,
                ),
              )
            ],
          );
  }

  Color? get indicatorColor {
    return theme.elevatedButtonTheme.style?.foregroundColor
        ?.resolve(<MaterialState>{MaterialState.pressed})?.withOpacity(1);
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
      height: widget.height,
      width: widget.width ?? double.maxFinite,
      child: !widget.outline ? _buildElevated : _buildOutline,
    );
  }
}
