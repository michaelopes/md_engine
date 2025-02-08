import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';
import 'package:md_engine/src/core/i18n/app_translate.dart';

import '../helpers/md_responsive_metrics.dart';
import 'md_delegate.dart';

extension MdResponsiveMetricsExt on BuildContext {
  MdResponsiveMetrics get metrics => MdResponsiveMetrics.of(this);
}

extension StringTrExt on String {
  String tr(BuildContext context, {Map<String, String>? params}) {
    return AppTranslate.tr(
      this,
      context,
      params: params,
    );
  }
}

extension ListMdSubRouteExt on List<MdRoute> {
  MdRoute byName(String name) {
    return where((e) => e.config.name == name).first;
  }
}

extension EnumExt on Enum {
  String get text {
    return MdToolkit.I.enumToString(this).replaceAll("nnew", "new");
  }
}

extension EnumValuesExt on List<Enum> {
  T fromText<T extends Enum>(String value) {
    return MdToolkit.I.enumFromString(this, value.replaceAll("nnew", "new"))
        as T;
  }
}

extension QRContextExt on QRContext {
  Future<void> popAllUntilThis(BuildContext context) async {
    final isCurrent = ModalRoute.isCurrentOf(context);
    if (isCurrent == false) {
      await QR.back();
      return await popAllUntilThis(context);
    }
  }

  //Future<void> replaceAll(String path) async {}

  Future<bool> popUntil(String target, [dynamic result]) async {
    if (target.isEmpty) return false;
    final entries = [...QR.history.entries]..removeAt(0);

    if (entries.length > 1) {
      final routeTarget =
          target.startsWith("/") ? target.replaceFirst("/", "") : target;
      final rootRouteName = entries.first.key.name;
      final currentRouteName = QR.history.current.key.name;
      final isDialogOpen = MdDelegate.isCurrentRouteDialog;
      final c1 = rootRouteName == currentRouteName;
      final c2 = currentRouteName == routeTarget;
      if (!c1 && !c2 && !isDialogOpen) {
        await QR.navigator.removeLast(result: result);
        return await popUntil(target, result);
      } else if (isDialogOpen) {
        Navigator.pop(QR.context!);
        await Future.delayed(Duration(milliseconds: 10));
        return await popUntil(target, result);
      }
    }
    return true;
  }

  Future<void> popUntilAndPushNamed(
    String pushRouteName,
    String popRouteName, {
    Map<String, dynamic>? params,
  }) async {
    if (pushRouteName.isEmpty || popRouteName.isEmpty) return;
    if (await popUntil(popRouteName)) {
      Future.delayed(Duration(milliseconds: 50), () {
        QR.pushName(pushRouteName, params: params);
      });
    }
  }
}
