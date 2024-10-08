import 'package:flutter/material.dart';

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
      return Wrap(
        children: widget.children.map((e) {
          var isLast = widget.children.last == e;
          return e._calculatedWidget(
            parentWidth: constraints.maxWidth,
            crossAxisSpacing: _crossAxisSpacing,
            mainAxisSpacing: _mainAxisSpacing,
            isLast: isLast,
          );
        }).toList(),
      );
    });
  }
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

  Widget _calculatedWidget({
    required double parentWidth,
    required MdSpacing mainAxisSpacing,
    required MdSpacing crossAxisSpacing,
    required bool isLast,
  }) {
    var mainASpacing = _getSpacing(parentWidth, mainAxisSpacing);
    var crossASpacing = _getSpacing(parentWidth, crossAxisSpacing);
    var colWidth = parentWidth / 12;
    var colNumber = _getColsNumber(parentWidth);
    var maxWidth = (colWidth * colNumber);
    return colNumber == 0
        ? const SizedBox.shrink()
        : AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: colWidth * colNumber,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  right: isLast ? 0 : mainASpacing,
                  bottom: isLast ? 0 : crossASpacing,
                ),
                child: child,
              ),
            ),
          );
  }

  double _getSpacing(double parentWidth, MdSpacing spacing) {
    var metrics = MdResponsiveMetrics.fromSize(Size(parentWidth, 0));
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

  int _getColsNumber(double parentWidth) {
    if (all != null) {
      return all!.index;
    }
    var metrics = MdResponsiveMetrics.fromSize(Size(parentWidth, 0));
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
