import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import '../../widgets/md_sub_route_builder.dart';

final class MdRouteConfig {
  late final String path;
  final String name;

  // ignore: unused_field
  MdRouteConfig? _rootConfig;

  MdRouteConfig({String path = "", this.name = ""}) {
    if (path.isEmpty) {
      this.path = "/$name";
    }
  }

  String get fullPath =>
      _rootConfig != null ? "${_rootConfig!.path}$path" : path;
}

final class MdRoute {
  final MdRouteConfig config;
  final String transKey;
  final Widget icon;
  final Widget? activeIcon;
  Widget Function(QRouter? router)? builder;
  final List<MdRoute> children;

  MdRoute({
    required this.config,
    this.transKey = "",
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

  MdRoute _setRootConfig(MdRouteConfig rootConfig) {
    config._rootConfig = rootConfig;
    return this;
  }

  QRoute toQRRoute({
    List<QMiddleware>? middleware,
  }) {
    if (children.isNotEmpty) {
      return QRoute.withChild(
        name: config.name,
        path: config.path,
        initRoute: children.first.config.path,
        builderChild: (router) {
          return builder?.call(router) ?? MdSubRouteBuilder(router: router);
        },
        middleware: middleware,
        children: children
            .map(
              (e) => e._setRootConfig(config).toQRRoute(),
            )
            .toList(),
      );
    } else {
      return QRoute(
        name: config.name,
        path: config.path,
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
