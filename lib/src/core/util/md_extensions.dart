import 'package:flutter/material.dart';
import 'package:md_engine/src/core/i18n/app_translate.dart';

import '../helpers/md_responsive_metrics.dart';
import 'md_sub_route.dart';

extension MdResponsiveMetricsExt on BuildContext {
  MdResponsiveMetrics get metrics => MdResponsiveMetrics.of(this);
}

extension StringTrExt on String {
  String tr(BuildContext context) {
    return AppTranslate.tr(this, context);
  }
}

extension ListMdSubRouteExt on List<MdRoute> {
  MdRoute byName(String name) {
    return where((e) => e.config.name == name).first;
  }
}
