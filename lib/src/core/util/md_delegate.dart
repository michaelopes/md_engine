import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class MdDelegate extends QRouterDelegate {
  MdDelegate(
    List<QRoute> routes, {
    GlobalKey<NavigatorState>? navKey,
    String? initPath,
    bool withWebBar = false,
    bool alwaysAddInitPath = false,
    List<NavigatorObserver>? observers,
    String? restorationScopeId,
  }) : super(routes,
            alwaysAddInitPath: alwaysAddInitPath,
            initPath: initPath,
            navKey: navKey,
            observers: observers ?? [],
            restorationScopeId: restorationScopeId,
            withWebBar: withWebBar) {
    this.observers.add(_DelegateObserver(
      onChangeRoute: ((route) {
        currentRoute = route;
      }),
    ));
  }

  Route<dynamic>? currentRoute;

  @override
  Future<bool> popRoute() async {
    if (currentRoute != null) {
      final willPopResult = await currentRoute?.willPop();
      if (willPopResult == RoutePopDisposition.pop) {
        return super.popRoute();
      } else {
        return true;
      }
    } else {
      return super.popRoute();
    }
  }
}

class _DelegateObserver extends NavigatorObserver {
  _DelegateObserver({
    required this.onChangeRoute,
  });

  final void Function(Route<dynamic> route) onChangeRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onChangeRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) onChangeRoute(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) onChangeRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) onChangeRoute(newRoute);
  }
}
