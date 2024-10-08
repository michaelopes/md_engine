import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MdIconType { svg, png }

class MdIcn extends StatelessWidget {
  const MdIcn({
    this.icon,
    Key? key,
    this.fit,
    this.color,
    this.width,
    this.height,
    this.onTap,
    this.padding,
  }) : super(key: key);

  final String? icon;
  final BoxFit? fit;
  final Color? color;
  final double? height;
  final double? width;
  final Function? onTap;
  final EdgeInsetsGeometry? padding;

  MdIcn copyWith({Color? color}) {
    return MdIcn(
      color: color ?? this.color,
      fit: fit,
      height: height,
      icon: icon,
      key: key,
      onTap: onTap,
      width: width,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: !(icon ?? "").contains("png")
          ? SvgPicture.asset(
              icon ?? "",
              fit: fit ?? BoxFit.none,
              // ignore: deprecated_member_use
              color: color,
              width: width,
              height: height,
            )
          : Image.asset(
              icon!,
              width: width,
              height: height,
              filterQuality: FilterQuality.high,
            ),
    );
  }
}
