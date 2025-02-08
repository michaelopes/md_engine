import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdAssetIcon {
  final String fileName;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final bool package;

  final _pathEngine = "packages/md_engine/lib/icons";

  const MdAssetIcon({
    required this.fileName,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.package = false,
  });

  MdIcn call({double? width, double? height, BoxFit? fit, Color? color}) {
    return MdIcn(
      color: color,
      fit: fit,
      height: height,
      width: width,
      icon: package ? "$_pathEngine/$fileName" : fileName,
    );
  }
}
