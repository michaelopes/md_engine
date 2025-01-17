import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../core/base/md_state.dart';

class MDSelectFieldItem {
  final dynamic key;
  final String? text;
  final Widget? prefix;

  MDSelectFieldItem({
    this.key,
    this.text,
    this.prefix,
  });
}

class MDSelectField extends StatefulWidget {
  final List<MDSelectFieldItem?> items;
  final int selectedIndex;
  final Function(
    MDSelectFieldItem? item,
    int index,
  )? onChanged;
  final String? labeltext;
  final double? borderRadius;
  final Widget? icon;
  final String? hintText;

  const MDSelectField({
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
  State<MDSelectField> createState() => _MDSelectFieldState();
}

class _MDSelectFieldState extends MdState<MDSelectField> {
  @override
  void initState() {
    super.initState();
    selected = widget.items[widget.selectedIndex]!;
  }

  late MDSelectFieldItem selected;

  @override
  void didUpdateWidget(covariant MDSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.items[widget.selectedIndex]!;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return DropdownButtonHideUnderline(
        child: DropdownButton2<MDSelectFieldItem>(
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
            return DropdownMenuItem<MDSelectFieldItem>(
              value: item,
              enabled: true,
              child: Text(
                item!.text ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          value: selected,
          onChanged: (MDSelectFieldItem? value) {
            if (value != null) {
              setState(() {
                selected = value;
              });
              widget.onChanged?.call(value, widget.items.indexOf(value));
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 52,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
            elevation: 2,
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
            offset: const Offset(0, -4),
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
