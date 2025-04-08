import 'dart:async';

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

  String get textUnderscoreCase {
    return MdToolkit.I.camelToUnderscore(
      MdToolkit.I.enumToString(this).replaceAll("nnew", "new"),
    );
  }
}

extension EnumValuesExt on List<Enum> {
  T fromText<T extends Enum>(String value) {
    return MdToolkit.I.enumFromString(this, value.replaceAll("nnew", "new"))
        as T;
  }
}

extension QRContextExt on QRContext {
  bool get hasOpenedDialog {
    return MdDelegate.isCurrentRouteDialog;
  }

  Future<void> popUntilToCurrent() async {
    await popUntil(QR.currentPath);
  }

  Future<void> popUntilNamed(String name) async {
    final treeFilter = QR.treeInfo.namePath.entries.where((e) => e.key == name);
    if (treeFilter.isNotEmpty) {
      final path = treeFilter.first.value;
      await popUntil(path);
    } else {
      final rootPath = QR.treeInfo.namePath["Root"];
      if (rootPath != null && rootPath.isNotEmpty) {
        await QR.popUntilOrPush(rootPath);
      }
    }
  }

  Future<void> popUntil(String path) async {
    final filter =
        QR.history.entries.where((e) => Uri.parse(e.path).path == path);
    if (filter.isNotEmpty) {
      final route = filter.first;
      final uri = Uri.parse(route.path);

      if (uri.path == QR.currentPath) {
        if (hasOpenedDialog) {
          final bResult = await QR.back();
          if (bResult == PopResult.PopupDismissed) {
            return await popUntil(path);
          }
        }
        return;
      }

      final treeFilter =
          QR.treeInfo.namePath.entries.where((e) => e.value == uri.path);
      if (treeFilter.isNotEmpty) {
        String rName = treeFilter.first.key;
        if (uri.path == "/") {
          rName = treeFilter.last.key;
        }
        await QR.popUntilOrPushName(
          rName,
          params: filter.first.params.asValueMap,
        );
      }
    } else {
      final rootPath = QR.treeInfo.namePath["Root"];
      if (rootPath != null && rootPath.isNotEmpty) {
        await QR.popUntilOrPush(rootPath);
      }
    }
  }
}
