import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdSelectFieldItem {
  final dynamic key;
  final String? text;
  final Widget? prefix;

  MdSelectFieldItem({
    this.key,
    this.text,
    this.prefix,
  });
}

class MdSelectField extends StatefulWidget {
  final List<MdSelectFieldItem?> items;
  final int selectedIndex;
  final Function(
    MdSelectFieldItem? item,
    int index,
  )? onChanged;
  final String? labeltext;
  final double? borderRadius;
  final Widget? icon;
  final String? hintText;

  const MdSelectField({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onChanged,
    this.labeltext,
    this.icon,
    this.borderRadius,
    this.hintText,
  });

  @override
  State<MdSelectField> createState() => _MdSelectFieldState();
}

class _MdSelectFieldState extends MdState<MdSelectField> {
  @override
  void initState() {
    super.initState();
    selected = widget.items[widget.selectedIndex]!;
  }

  late MdSelectFieldItem selected;

  @override
  void didUpdateWidget(covariant MdSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.items[widget.selectedIndex]!;
  }

  InputDecorationTheme get _baseInputDecoration => theme.inputDecorationTheme;

  BorderRadius get _borderRadius {
    if (_baseInputDecoration.enabledBorder?.isOutline ?? false) {
      final b = _baseInputDecoration.enabledBorder as OutlineInputBorder;
      return b.borderRadius;
    }

    return BorderRadius.circular(4);
  }

  Color get _borderColor {
    if (_baseInputDecoration.enabledBorder != null) {
      final b = _baseInputDecoration.enabledBorder!;
      return b.borderSide.color;
    }
    return theme.colorScheme.primary;
  }

  double get _borderWidth {
    if (_baseInputDecoration.enabledBorder != null) {
      final b = _baseInputDecoration.enabledBorder!;
      return b.borderSide.width;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return DropdownButtonHideUnderline(
        child: DropdownButton2<MdSelectFieldItem>(
          isExpanded: true,
          hint: widget.hintText == null
              ? null
              : Row(
                  children: [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: theme.inputDecorationTheme.prefixIconColor,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        widget.hintText ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.inputDecorationTheme.hintStyle?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
          items: widget.items.map((item) {
            return DropdownMenuItem<MdSelectFieldItem>(
              value: item,
              enabled: true,
              child: Text(
                item!.text ?? "",
                style: _baseInputDecoration.labelStyle,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          value: selected,
          onChanged: (MdSelectFieldItem? value) {
            if (value != null) {
              setState(() {
                selected = value;
              });
              widget.onChanged?.call(value, widget.items.indexOf(value));
            }
          },
          buttonStyleData: ButtonStyleData(
            height: kDefaultMdTextFormFieldHeight,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
                borderRadius: _borderRadius,
                color: _baseInputDecoration.fillColor,
                border: Border.all(
                  color: _borderColor,
                  width: _borderWidth,
                )),
            elevation: 0,
          ),
          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            iconSize: 16,
            iconEnabledColor:
                Theme.of(context).inputDecorationTheme.prefixIconColor,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            width: constraints.maxWidth > 200 ? constraints.biggest.width : 200,
            maxHeight: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),

            direction: DropdownDirection.left,
            useRootNavigator: true,
            useSafeArea: true,
            //    offset: Offset(50, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(8),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      );
    });

    /*Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
      ),
      clipBehavior: Clip.none,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Theme(
            data: ThemeData(canvasColor: _bgColor),
            child: DropdownButtonFormField<MDSelectFieldItem>(
              isExpanded: true,
              value: selected,
              icon: widget.icon ??
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: theme
                        .extraOption("selectField")
                        .backgroundColor
                        .onBackgroundColor,
                    size: 22,
                  ),
              iconSize: 24,
              elevation: 16,
              itemHeight: _itemHeight,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: theme.extraOption("selectField").textStyle(1),
              onChanged: (newValue) {
                setState(() {
                  selected = newValue!;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue, widget.items.indexOf(newValue));
                }
              },
              selectedItemBuilder: (context) => widget.items.map((model) {
                var text = Row(
                  children: [
                    if (model?.prefix != null) model!.prefix!,
                    Text(
                      model?.text ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: theme.extraOption("selectField").textStyle(1),
                    ),
                  ],
                );
                return Container(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (widget.labeltext != null &&
                          widget.labeltext!.isNotEmpty)
                        Positioned(
                          top: -8,
                          child: Text(
                            widget.labeltext!,
                            style:
                                theme.extraOption("selectField").textStyle(2),
                          ),
                        ),
                      widget.labeltext != null && widget.labeltext!.isNotEmpty
                          ? Positioned(top: 10, child: text)
                          : text,
                    ],
                  ),
                );
              }).toList(),
              
              items: widget.items.map(
                (model) {
                  var isSelected = model?.key == selected.key;
                  return DropdownMenuItem<MDSelectFieldItem>(
                    value: model,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (isSelected) ...[
                          Positioned(
                            left: -16,
                            top: 0,
                            child: Container(
                              height: _itemHeight,
                              width: 16,
                              color: theme
                                  .extraOption("selectField")
                                  .color("active"),
                            ),
                          ),
                          Positioned(
                            right: -16,
                            top: 0,
                            child: Container(
                              height: _itemHeight,
                              width: 16,
                              color: theme
                                  .extraOption("selectField")
                                  .color("active"),
                            ),
                          ),
                        ],
                        UnconstrainedBox(
                          child: Container(
                            width: 180,
                            height: _itemHeight,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme
                                      .extraOption("selectField")
                                      .color("active")
                                  : Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (model?.prefix != null) model!.prefix!,
                                      Text(
                                        model?.text ?? "",
                                        style: theme.bodyMedium.copyWith(
                                            color: isSelected
                                                ? theme
                                                    .extraOption("selectField")
                                                    .color("onActive")
                                                : null),
                                      ),
                                    ],
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color: theme
                                          .extraOption("selectField")
                                          .color("onActive"),
                                      size: 20,
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    )*/
  }
}
