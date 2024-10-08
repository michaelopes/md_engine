import 'package:flutter/material.dart';
import 'package:md_engine/src/widgets/md_height.dart';

import '../core/base/md_state.dart';
import '../core/util/md_toolkit.dart';

class MdCarrousel extends StatefulWidget {
  const MdCarrousel({
    super.key,
    required this.children,
    this.height = 0,
    this.maxScale = 1.0,
    this.minScale = 0.9,
    this.defaultPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.initialLeftTranslate = 0,
  });
  final List<Widget> children;
  final double height;
  final double maxScale;
  final double minScale;
  final EdgeInsets defaultPadding;
  final double initialLeftTranslate;
  @override
  State<MdCarrousel> createState() => _MdCarrouselState();
}

class _MdCarrouselState extends MdState<MdCarrousel> {
  int _activePage = 0;
  late PageController _pageController;
  late List<GlobalKey> _keys;

  double _h = 0;
  bool _wait = false;

  @override
  void initState() {
    super.initState();
    _createController();

    _setup();
  }

  _createController() {
    _keys = widget.children.map((e) => GlobalKey()).toList();
    _pageController = PageController(
      keepPage: true,
      viewportFraction: widget.children.length > 1 ? 0.82 : 1,
      initialPage: 0,
    );
  }

  _setup() {
    if (widget.height == 0) {
      _calcH(ajust: 0);
    } else {
      _h = widget.height * ((widget.maxScale - widget.minScale) + 1);
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _createController();
    _setup();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createController();
    _setup();
  }

  void _calcH({double ajust = 0}) {
    RenderBox? getObj() {
      return _keys[_activePage].currentContext?.findRenderObject()
          as RenderBox?;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_wait) {
        _wait = true;
        MdToolkit.I.when(() => getObj() != null, () {
          var obj = getObj();
          if (obj != null) {
            setState(() {
              _h = obj.size.height + ajust;
              _wait = false;
            });
          }
        }, 200);
      }
    });
  }

  Widget _buildItem(int index) {
    var sc = widget.children.length > 1
        ? _activePage == index
            ? widget.maxScale
            : widget.minScale
        : 1.0;
    return Transform.translate(
      offset: _activePage == 0 && widget.children.length > 1
          ? Offset(widget.initialLeftTranslate, 0)
          : const Offset(0, 0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          key: _keys[index],
          child: AnimatedScale(
            scale: sc,
            duration: const Duration(milliseconds: 500),
            child: widget.children[index],
          ),
        ),
      ),
    );
  }

  Widget get _buildIndicator {
    var index = 0;
    return Row(
      children: widget.children.map((e) {
        var active = index == _activePage;
        var wd = AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(.5),
          ),
          duration: const Duration(milliseconds: 500),
          width: active ? 20 : 10,
          height: 10,
        );
        index++;
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: wd,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.children.length == 1 ? widget.defaultPadding : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: _h,
            child: PageView.builder(
              itemCount: widget.children.length,
              //ð    pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() => _activePage = page);
                if (widget.height == 0) _calcH();
              },
              itemBuilder: (context, index) {
                return _buildItem(index);
              },
            ),
          ),
          if (widget.children.length > 1) ...[
            const MdHeight(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIndicator,
              ],
            )
          ]
        ],
      ),
    );
  }
}
