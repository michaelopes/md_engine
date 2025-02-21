import 'package:flutter/material.dart';
import 'package:md_engine/src/widgets/md_height.dart';

import '../core/base/md_stateless.dart';

class MdBottomSheet extends MdStateless {
  MdBottomSheet({
    super.key,
    required this.child,
    this.message = "",
    this.title = "",
    this.bottomNavigatorAjust = 0,
    this.minHeight = 200,
  });

  final String title;
  final String message;
  final Widget child;
  final double bottomNavigatorAjust;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom + bottomNavigatorAjust,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: theme.bottomSheetTheme.modalBackgroundColor,
              ),
              constraints: BoxConstraints(
                minHeight: minHeight,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 32, bottom: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: title.isNotEmpty || message.isNotEmpty
                                      ? 12
                                      : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (title.isNotEmpty) ...[
                                    const MdHeight(4),
                                    Text(
                                      title,
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                  if (message.isNotEmpty) ...[
                                    const MdHeight(8),
                                    Text(
                                      message,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -14,
                            right: 0,
                            left: 0,
                            child: UnconstrainedBox(
                              child: Container(
                                height: 3.5,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: theme.bottomSheetTheme.dragHandleColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24)
                        .copyWith(top: title.isEmpty ? 8 : 0)
                        .copyWith(bottom: 32),
                    child: child,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
