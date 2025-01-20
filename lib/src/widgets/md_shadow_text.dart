import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MdShadowText extends StatelessWidget {
  const MdShadowText(this.text,
      {super.key, this.style, this.textAlign, this.sigma = 2});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double sigma;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: sigma,
            left: sigma,
            child: Text(
              text,
              textAlign: textAlign,
              style: style?.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
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
