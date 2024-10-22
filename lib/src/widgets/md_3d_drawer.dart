import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:md_engine/src/core/base/md_state.dart';

class Md3dDrawer extends StatefulWidget {
  const Md3dDrawer({
    super.key,
    required this.body,
    required this.drawer,
  });

  final Widget body;
  final Widget drawer;

  @override
  Md3dDrawerState createState() => Md3dDrawerState();
}

class Md3dDrawerState extends MdState<Md3dDrawer> {
  double _valueToAnimation = 0;

  bool isOpen() {
    return _valueToAnimation == 1;
  }

  void open() {
    setState(() {
      _valueToAnimation = 1;
    });
  }

  void close() {
    setState(() {
      _valueToAnimation = 0;
    });
  }

  void toggle() {
    setState(() {
      _valueToAnimation == 0 ? _valueToAnimation = 1 : _valueToAnimation = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.background,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(child: widget.drawer),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: _valueToAnimation),
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            builder: (_, double value, __) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 230 * value)
                  ..rotateY((pi / 6) * value),
                child: Stack(
                  children: [
                    widget.body,
                    if (isOpen())
                      GestureDetector(
                        onTap: () {
                          close();
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.transparent,
                        ),
                      )
                  ],
                ),
              );
            },
          ),
          SizedBox(
            width: !isOpen() ? 40 : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              dragStartBehavior: DragStartBehavior.down,
              onHorizontalDragUpdate: (e) {
                if (e.delta.dx > 6) {
                  open();
                } else if (e.delta.dx < -6) {
                  close();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
