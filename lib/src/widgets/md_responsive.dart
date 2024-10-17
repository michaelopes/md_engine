import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:md_engine/src/core/util/md_screen_utility.dart';

import '../core/helpers/md_responsive_metrics.dart';

enum MdSize {
  none,
  col1,
  col2,
  col3,
  col4,
  col5,
  col6,
  col7,
  col8,
  col9,
  col10,
  col11,
  col12,
}

enum MdLayoutType {
  sm,
  md,
  lg,
  xl,
}

final class MdSpacing {
  final double sm;
  final double md;
  final double lg;
  final double xl;

  MdSpacing({
    this.sm = 0,
    this.md = 0,
    this.lg = 0,
    this.xl = 0,
  });
}

final class MdSizeMacro {
  final List<(MdLayoutType layoutType, MdSize s)> layouts;
  final MdSize standard;

  MdSizeMacro(this.layouts, {required this.standard});

  MdSize get(MdLayoutType layoutType) {
    final result = layouts.firstWhereOrNull((e) => e.$1 == layoutType)?.$2;
    return result ?? standard;
  }
}

class MdRow extends StatefulWidget {
  const MdRow({
    super.key,
    required this.children,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });

  final List<MdCol> children;
  final MdSpacing? mainAxisSpacing;
  final MdSpacing? crossAxisSpacing;

  @override
  State<MdRow> createState() => _MdRowState();
}

class _MdRowState extends State<MdRow> {
  late final _mainAxisSpacing = (widget.mainAxisSpacing ?? MdSpacing());
  late final _crossAxisSpacing = (widget.crossAxisSpacing ?? MdSpacing());
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final screenWidth = MdScreenUtility.I.width;
      return SizedBox.expand(
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: widget.children.map((e) {
            var isLast = widget.children.last == e;
            return e._calculatedWidget(
              parentWidth: constraints.maxWidth,
              screenWidth: screenWidth,
              crossAxisSpacing: _crossAxisSpacing,
              mainAxisSpacing: _mainAxisSpacing,
              maxHeight: constraints.maxHeight,
              isLast: isLast,
            );
          }).toList(),
        ),
      );
    });
  }
}

final class MdCol {
  final MdSize sm;
  final MdSize md;
  final MdSize lg;
  final MdSize xl;
  final MdSize? all;
  final Widget child;

  MdCol({
    this.sm = MdSize.col12,
    this.md = MdSize.col12,
    this.lg = MdSize.col12,
    this.xl = MdSize.col12,
    this.all,
    required this.child,
  });

  factory MdCol.macro({
    required MdSizeMacro value,
    required Widget child,
  }) {
    return MdCol(
      sm: value.get(MdLayoutType.sm),
      md: value.get(MdLayoutType.md),
      lg: value.get(MdLayoutType.lg),
      xl: value.get(MdLayoutType.xl),
      child: child,
    );
  }

  factory MdCol.offsetMacro({
    required MdSizeMacro value,
  }) {
    return MdCol(
      sm: value.get(MdLayoutType.sm),
      md: value.get(MdLayoutType.md),
      lg: value.get(MdLayoutType.lg),
      xl: value.get(MdLayoutType.xl),
      child: const SizedBox.shrink(),
    );
  }

  factory MdCol.offset({
    MdSize sm = MdSize.none,
    MdSize md = MdSize.none,
    MdSize lg = MdSize.none,
    MdSize xl = MdSize.none,
  }) {
    return MdCol(
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: const SizedBox.shrink(),
    );
  }

  Widget _calculatedWidget({
    required double parentWidth,
    required double screenWidth,
    required MdSpacing mainAxisSpacing,
    required MdSpacing crossAxisSpacing,
    required double maxHeight,
    required bool isLast,
  }) {
    var mainASpacing = _getSpacing(screenWidth, mainAxisSpacing);
    var crossASpacing = _getSpacing(screenWidth, crossAxisSpacing);
    var colNumber = _getColsNumber(screenWidth);
    var colWidth = parentWidth / 12;
    var maxWidth = (colWidth * colNumber).floorToDouble();

    return colNumber == 0
        ? const SizedBox.shrink()
        : ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                right: isLast ? 0 : mainASpacing,
                bottom: isLast ? 0 : crossASpacing,
              ),
              child: child,
            ),
          );
  }

  double _getSpacing(double screenWidth, MdSpacing spacing) {
    var metrics = MdResponsiveMetrics.fromSize(Size(screenWidth, 0));
    double result;
    if (metrics.isXL) {
      result = spacing.xl;
    } else if (metrics.isLG) {
      result = spacing.lg;
    } else if (metrics.isMD) {
      result = spacing.md;
    } else {
      result = spacing.sm;
    }
    return result;
  }

  int _getColsNumber(double screenWidth) {
    if (all != null) {
      return all!.index;
    }
    var metrics = MdResponsiveMetrics.fromSize(Size(screenWidth, 0));
    int result;
    if (metrics.isXL) {
      result = xl.index;
    } else if (metrics.isLG) {
      result = lg.index;
    } else if (metrics.isMD) {
      result = md.index;
    } else {
      result = sm.index;
    }
    return result;
  }
}
