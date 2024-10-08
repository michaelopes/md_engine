import 'package:flutter/widgets.dart';

import '../core/helpers/md_responsive_metrics.dart';

typedef MdLayoutBuilder = Widget Function(BuildContext context, Size size);

class MdLayout extends StatefulWidget {
  final MdLayoutBuilder sm;
  final MdLayoutBuilder md;
  final MdLayoutBuilder lg;
  final MdLayoutBuilder xl;

  const MdLayout.builder({
    super.key,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  factory MdLayout.builderByDevice({
    Key? key,
    required MdLayoutBuilder mobile,
    required MdLayoutBuilder tablet,
    required MdLayoutBuilder desktop,
  }) {
    return MdLayout.builder(
      lg: desktop,
      xl: desktop,
      md: tablet,
      sm: mobile,
    );
  }

  @override
  State<MdLayout> createState() => _MdLayoutState();
}

class _MdLayoutState extends State<MdLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var metrics = MdResponsiveMetrics.of(context);

    Widget result;
    if (metrics.isXL) {
      result = widget.xl(context, metrics.size);
    } else if (metrics.isLG) {
      result = widget.lg(context, metrics.size);
    } else if (metrics.isMD) {
      result = widget.md(context, metrics.size);
    } else {
      result = widget.sm(context, metrics.size);
    }
    return result;
  }
}
