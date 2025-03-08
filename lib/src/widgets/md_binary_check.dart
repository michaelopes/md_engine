import 'package:flutter/material.dart';

import '../../md_engine.dart';

class MdBinaryCheckItem {
  final dynamic key;
  final String text;
  bool selected;

  MdBinaryCheckItem({
    required this.key,
    required this.text,
    this.selected = false,
  });
}

class MdFormBinaryCheck extends FormField<MdBinaryCheckItem> {
  MdFormBinaryCheck({
    super.key,
    required this.option01,
    required this.option02,
    required this.onCheck,
    super.validator,
    this.label = "",
    super.enabled = true,
  }) : super(
          builder: (FormFieldState<MdBinaryCheckItem> field) {
            final _MdFormBinaryCheckState state =
                field as _MdFormBinaryCheckState;
            void onCheckHandler(MdBinaryCheckItem value) {
              field.didChange(value);
              onCheck(value);
            }

            field._getSelectedItem = state._getSelectedItem;
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: MdBinaryCheck(
                label: label,
                onCheck: onCheckHandler,
                option01: option01,
                option02: option02,
                enabled: enabled,
              ),
            );
          },
        );

  final MdBinaryCheckItem option01;
  final MdBinaryCheckItem option02;
  final void Function(MdBinaryCheckItem item) onCheck;
  final String label;

  @override
  FormFieldState<MdBinaryCheckItem> createState() => _MdFormBinaryCheckState();
}

class _MdFormBinaryCheckState extends FormFieldState<MdBinaryCheckItem> {
  MdBinaryCheckItem Function()? _getSelectedItem;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    setValue(_getSelectedItem?.call());
  }

  @override
  void didUpdateWidget(MdFormBinaryCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    setValue(_getSelectedItem?.call());
  }

  @override
  Widget build(BuildContext context) {
    var superW = super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        superW,
        if (errorText != null) ...[
          Row(
            children: [
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 22,
                width: 22,
                child: Icon(
                  Icons.warning,
                  size: 12,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  errorText ?? "",
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          ),
        ]
      ],
    );
  }

  @override
  void didChange(MdBinaryCheckItem? value) {
    setValue(value);
    validate();
    super.didChange(value);
  }
}

class MdBinaryCheck extends StatefulWidget {
  const MdBinaryCheck({
    super.key,
    required this.option01,
    required this.option02,
    required this.onCheck,
    this.label = "",
    this.enabled = true,
  });

  final MdBinaryCheckItem option01;
  final MdBinaryCheckItem option02;
  final void Function(MdBinaryCheckItem item) onCheck;
  final String label;
  final bool enabled;

  @override
  State<MdBinaryCheck> createState() => _MdBinaryCheckState();
}

class _MdBinaryCheckState extends MdState<MdBinaryCheck> {
  MdBinaryCheckItem? _selectedItem;
  // ignore: unused_element
  MdBinaryCheckItem? _getSelectedItem() {
    return _selectedItem;
  }

  BorderRadius get _borderRadius {
    if (!widget.enabled) {
      if (theme.inputDecorationTheme.disabledBorder?.isOutline ?? false) {
        final b =
            theme.inputDecorationTheme.disabledBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else {
      if (theme.inputDecorationTheme.enabledBorder?.isOutline ?? false) {
        final b =
            theme.inputDecorationTheme.enabledBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    }

    return BorderRadius.circular(6);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: theme.inputDecorationTheme.labelStyle?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const MdHeight(8)
        ],
        Container(
          width: double.maxFinite,
          constraints: BoxConstraints(minHeight: kDefaultMdTextFormFieldHeight),
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: theme.inputDecorationTheme.fillColor,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ToggleButtons(
                isSelected: [
                  widget.option01.selected,
                  widget.option02.selected
                ],
                borderColor:
                    theme.inputDecorationTheme.enabledBorder?.borderSide.color,
                selectedBorderColor:
                    theme.inputDecorationTheme.focusedBorder?.borderSide.color,
                selectedColor: theme.colorScheme.primary,
                textStyle: theme.inputDecorationTheme.labelStyle,
                fillColor: theme.inputDecorationTheme.fillColor,
                color: theme.colorScheme.onSurface,
                borderWidth: 2,
                borderRadius: _borderRadius,
                onPressed: (index) {
                  if (!widget.enabled) return;
                  setState(() {
                    if (index == 0) {
                      widget.option02.selected = false;
                      widget.option01.selected = true;
                      _selectedItem = widget.option01;
                      widget.onCheck(widget.option01);
                    } else {
                      widget.option02.selected = true;
                      widget.option01.selected = false;
                      _selectedItem = widget.option02;
                      widget.onCheck(widget.option02);
                    }
                  });
                },
                children: [
                  SizedBox(
                    width: (constraints.biggest.width / 2) - 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        widget.option01.text,
                        textAlign: TextAlign.center,
                        style: theme.inputDecorationTheme.labelStyle?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: widget.option01.selected
                                ? theme.inputDecorationTheme.focusedBorder
                                    ?.borderSide.color
                                : null),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (constraints.biggest.width / 2) - 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        widget.option02.text,
                        textAlign: TextAlign.center,
                        style: theme.inputDecorationTheme.labelStyle?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: widget.option02.selected
                                ? theme.inputDecorationTheme.focusedBorder
                                    ?.borderSide.color
                                : null),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
