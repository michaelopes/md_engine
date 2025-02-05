import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';
import 'package:md_engine/src/core/i18n/app_translate.dart';

import '../helpers/md_responsive_metrics.dart';

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

extension QRContextExt on QRContext {
  void popAllUntilThis(BuildContext context) {
    final isCurrent = ModalRoute.isCurrentOf(context);
    if (isCurrent == false) {
      QR.back();
      return popAllUntilThis(context);
    }
  }
}
