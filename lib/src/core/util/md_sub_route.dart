import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import '../../widgets/md_sub_route_builder.dart';

class MdSubRoute {
  final String path;
  final String name;
  final String transKey;
  final Widget icon;
  final Widget? activeIcon;
  Widget Function(QRouter? router)? builder;
  final List<MdSubRoute> children;

  MdSubRoute({
    required this.path,
    required this.name,
    required this.transKey,
    this.builder,
    this.icon = const SizedBox.shrink(),
    this.activeIcon,
    this.children = const [],
  });

  Widget getStatedIcon(bool isActive) {
    if (isActive && activeIcon != null) {
      return activeIcon!;
    }
    return icon;
  }

  QRoute toQRRoute({
    List<QMiddleware>? middleware,
  }) {
    if (children.isNotEmpty) {
      return QRoute.withChild(
        name: name,
        path: path,
        initRoute: children.first.path,
        builderChild: (router) {
          return builder?.call(router) ?? MdSubRouteBuilder(router: router);
        },
        middleware: middleware,
        children: children
            .map(
              (e) => e.toQRRoute(),
            )
            .toList(),
      );
    } else {
      return QRoute(
        path: path,
        name: name,
        pageType: const QFadePage(),
        builder: () =>
            builder?.call(null) ??
            Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  "Page builder not found!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        middleware: middleware,
      );
    }
  }
}
