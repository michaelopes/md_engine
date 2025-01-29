import 'package:flutter/material.dart';

class MdAssetImage {
  final String fileName;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const MdAssetImage({
    required this.fileName,
    this.width,
    this.height,
    this.fit,
  });

  void precache(BuildContext context) {
    precacheImage(AssetImage(fileName), context);
  }

  Widget call({
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          fileName,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        ),
      ),
    );
  }
}
