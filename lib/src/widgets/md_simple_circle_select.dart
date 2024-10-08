import 'package:flutter/material.dart';
import 'package:md_engine/src/core/base/md_stateless.dart';

class MdSimpleCircleSelectItem {
  final dynamic reference;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool hideText;
  final bool enable;

  MdSimpleCircleSelectItem({
    this.text = "",
    this.hideText = false,
    required this.reference,
    required this.backgroundColor,
    required this.textColor,
    this.enable = true,
  });
}

class MdSimpleCircleSelect extends MdStateless {
  MdSimpleCircleSelect({
    super.key,
    required this.items,
    required this.ckeckIsSelected,
    required this.onChanged,
    this.dense = false,
  });
  final bool dense;
  final bool Function(MdSimpleCircleSelectItem item) ckeckIsSelected;
  final void Function(MdSimpleCircleSelectItem item) onChanged;
  final List<MdSimpleCircleSelectItem> items;

  Widget _buildItem(MdSimpleCircleSelectItem item) {
    return GestureDetector(
      onTap: () {
        if (item.enable) {
          onChanged(item);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          right: items.isNotEmpty && items.last == item ? 0 : 6,
        ),
        padding: const EdgeInsets.all(.8),
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ckeckIsSelected(item)
              ? theme.colorScheme.background
              : Colors.transparent,
          border: ckeckIsSelected(item)
              ? Border.all(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                )
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.backgroundColor.withOpacity(item.enable ? 1 : .5),
          ),
          alignment: Alignment.center,
          child: Text(
            !item.hideText ? item.text : "",
            style: theme.textTheme.bodySmall?.copyWith(
              color: item.textColor.withOpacity(item.enable ? 1 : .6),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !dense ? double.infinity : null,
      child: Container(
        alignment: dense ? Alignment.centerLeft : Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment:
                dense ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: items
                .map(
                  (e) => _buildItem(e),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
