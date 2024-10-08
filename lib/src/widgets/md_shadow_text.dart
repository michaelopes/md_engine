import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MdShadowText extends StatelessWidget {
  const MdShadowText(this.text, {super.key, this.style, this.textAlign});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: 2.0,
            left: 2.0,
            child: Text(
              text,
              textAlign: textAlign,
              style: style?.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Text(
              text,
              style: style,
              textAlign: textAlign,
            ),
          ),
        ],
      ),
    );
  }
}
