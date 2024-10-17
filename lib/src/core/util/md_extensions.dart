import 'package:flutter/material.dart';

import '../helpers/md_responsive_metrics.dart';

extension MdResponsiveMetricsExt on BuildContext {
  MdResponsiveMetrics get metrics => MdResponsiveMetrics.of(this);
}
