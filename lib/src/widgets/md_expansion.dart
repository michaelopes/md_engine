import 'package:flutter/material.dart';

import '../core/base/md_state.dart';
import '../core/util/md_toolkit.dart';

class MdExpansion extends StatefulWidget {
  const MdExpansion({
    super.key,
    this.title = const Text(""),
    required this.children,
    this.showHeader = true,
    this.initialExpanded = false,
    this.maxHeight,
  });

  final Widget title;
  final bool showHeader;
  final List<Widget> children;
  final bool initialExpanded;
  final double? maxHeight;

  @override
  State<MdExpansion> createState() => MdExpansionState();
}

class MdExpansionState extends MdState<MdExpansion> {
  final _key = GlobalKey();
  final _controller = ScrollController();
  double _h = 0;
  double _maxH = 0;
  late bool _ready;

  @override
  void initState() {
    super.initState();
    _ready = false;
    _setup();
  }

  @override
  void didUpdateWidget(covariant MdExpansion oldWidget) {
    if (oldWidget != widget) {
      _setup(isUpdate: true);
    }
    super.didUpdateWidget(oldWidget);
  }

  RenderBox? get _rBox => _key.currentContext?.findRenderObject() as RenderBox?;
  void _setup({bool isUpdate = false}) {
    MdToolkit.I.when(() => _rBox != null, () {
      if (_rBox != null) {
        _maxH = _rBox?.semanticBounds.height ?? 0;
        if (widget.maxHeight != null && _maxH > widget.maxHeight!) {
          _maxH = widget.maxHeight!;
        }
        if (widget.initialExpanded && !isUpdate) {
          toogle();
        }
      }
      _ready = true;
    }, 50);
  }

  bool _changeSize(SizeChangedLayoutNotification notification) {
    if (isExpanded && _rBox != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          _maxH = _rBox?.semanticBounds.height ?? 0;
          if (widget.maxHeight != null && _maxH > widget.maxHeight!) {
            _maxH = widget.maxHeight!;
          }
          setState(() {
            _h = _maxH;
          });
        },
      );
    }
    return true;
  }

  bool get isExpanded => _ready ? _h > 0 : widget.initialExpanded;

  void toogle() {
    setState(() {
      _h = _h > 0 ? 0 : _maxH;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.showHeader)
          InkWell(
            onTap: toogle,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.title,
                  Icon(
                    _h > 0
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: theme.colorScheme.onSurface.withOpacity(.8),
                    size: 24,
                  )
                ],
              ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.maxHeight != null
              ? _h >= widget.maxHeight!
                  ? _h - 20
                  : _h
              : _h,
          child: SingleChildScrollView(
            controller: _controller,
            child: NotificationListener<SizeChangedLayoutNotification>(
                onNotification: _changeSize,
                child: SizeChangedLayoutNotifier(
                  key: _key,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [...widget.children],
                    ),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
