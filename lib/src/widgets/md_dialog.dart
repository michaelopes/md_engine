import 'package:flutter/material.dart';
import 'package:md_engine/src/core/base/md_state.dart';
import 'package:md_engine/src/core/util/md_toolkit.dart';

import 'md_button.dart';
import 'md_height.dart';
import 'md_will_pop_scope.dart';

class MdDialog extends StatefulWidget {
  final String title;
  final String message;
  final String buttonText;
  final Function()? onTap;
  final Function()? onSecondaryTap;
  final String? buttonSecondaryText;
  final Widget? header;
  final Widget? body;
  final double? marginBottom;

  const MdDialog({
    super.key,
    this.title = "",
    this.message = "",
    required this.buttonText,
    this.onTap,
    this.onSecondaryTap,
    this.header,
    this.buttonSecondaryText,
    this.body,
    this.marginBottom = 32,
  });

  @override
  State<MdDialog> createState() => _MdDialogState();

  Future<dynamic> show(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = false,
    bool useSafeArea = false,
  }) {
    return showDialog(
      context: context,
      builder: (_) => this,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      barrierColor: barrierColor ??
          MdToolkit.I
              .getColorInverted(
                Theme.of(context).colorScheme.surface,
              )
              .withOpacity(.35),
    );
  }
}

class _MdDialogState extends MdState<MdDialog> {
  @override
  Widget build(BuildContext context) {
    return MdWillPopScope(
      onWillPop: () async => false,
      child: UnconstrainedBox(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 350,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: theme.dialogTheme.backgroundColor,
            elevation: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 30, left: 24, right: 24, bottom: 24),
                decoration: BoxDecoration(
                  color: theme.dialogTheme.backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.header != null) ...[
                      widget.header!,
                      const MdHeight(16)
                    ],
                    if (widget.title.isNotEmpty) ...[
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                    if (widget.message.isNotEmpty)
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    if (widget.body != null) widget.body!,
                    SizedBox(
                      height: widget.marginBottom,
                    ),
                    if (widget.buttonText.isNotEmpty)
                      MdButton(
                        height: 40,
                        width: 184,
                        text: widget.buttonText,
                        onPressed: widget.onTap,
                      ),
                    widget.buttonSecondaryText != null
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              TextButton(
                                onPressed: widget.onSecondaryTap,
                                child: Text(
                                  widget.buttonSecondaryText!,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                      color: MdToolkit.I.getColorInverted(
                                    theme.dialogTheme.backgroundColor ??
                                        theme.colorScheme.surface,
                                  )),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
