import 'package:flutter/material.dart';

class MdSubRoute {
  final String path;
  final String name;
  final String transKey;
  final Widget icon;
  final Widget? activeIcon;
  Widget Function() builder;

  MdSubRoute({
    required this.path,
    required this.name,
    required this.transKey,
    required this.icon,
    required this.builder,
    this.activeIcon,
  });

  Widget getStatedIcon(bool isActive) {
    if (isActive && activeIcon != null) {
      return activeIcon!;
    }
    return icon;
  }
}
