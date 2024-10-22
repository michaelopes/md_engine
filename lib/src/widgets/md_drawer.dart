import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

final class MdDrawerItem {
  final Widget Function(bool selected) icon;
  final String label;
  final String key;
  final List<MdDrawerItem> items;
  final VoidCallback? onRedirect;
  final VoidCallback? onOpen;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  MdDrawerItem({
    required this.icon,
    required this.label,
    required this.key,
    this.onRedirect,
    this.onOpen,
    this.items = const [],
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
  });
}

class MdDrawer extends StatefulWidget {
  const MdDrawer({
    super.key,
    required this.selectedItemKey,
    required this.items,
    this.backgroundColor,
    this.selectedItemBackgroundColor,
    this.header,
    this.footer,
    this.onChanged,
    this.padding,
    this.isDense = false,
  });

  final Widget? header;
  final Widget? footer;
  final String selectedItemKey;
  final Color? backgroundColor;
  final Color? selectedItemBackgroundColor;
  final EdgeInsets? padding;
  final bool isDense;

  final List<MdDrawerItem> items;
  final void Function(MdDrawerItem item)? onChanged;

  @override
  State<MdDrawer> createState() => _MdDrawerState();
}

class _MdDrawerState extends MdWidgetState<MdDrawer>
    with TickerProviderStateMixin {
  Widget _buildItem(MdDrawerItem item) {
    return MdDrawerMenuItem(
      item: item,
      selectedItemKey: widget.selectedItemKey,
      selectedItemBackgroundColor: widget.selectedItemBackgroundColor,
      rootBackgroundColor: widget.backgroundColor,
      isDense: widget.isDense,
    );
  }

  Widget get _buildContent {
    return Expanded(
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.items
                .map(
                  (e) => _buildItem(e),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Color? get _bgColor =>
      widget.backgroundColor ??
      (theme.brightness == Brightness.light
          ? const Color(0xFFF1F1F1)
          : Colors.black87);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: _bgColor ?? theme.colorScheme.background,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
          child: SizedBox(
            height: double.infinity,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.header != null) widget.header!,
                  _buildContent,
                  if (widget.footer != null) widget.footer!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  List<MdStateObs> get observables => [];
}

class MdDrawerMenuItem extends StatefulWidget {
  const MdDrawerMenuItem({
    super.key,
    required this.item,
    required this.selectedItemKey,
    this.rootBackgroundColor,
    this.selectedItemBackgroundColor,
    this.isOpen = false,
    this.isDense = false,
  });

  final MdDrawerItem item;
  final String selectedItemKey;
  final Color? selectedItemBackgroundColor;
  final Color? rootBackgroundColor;
  final bool isOpen;
  final bool isDense;

  @override
  State<MdDrawerMenuItem> createState() => _MdDrawerMenuItemState();
}

class _MdDrawerMenuItemState extends MdWidgetState<MdDrawerMenuItem> {
  bool isOpen = false;
  bool isSelected = false;

  @override
  void initState() {
    isOpen = widget.isOpen;
    isSelected = widget.selectedItemKey == widget.item.key;
    if (isSelected) {
      _openAll();
    }

    super.initState();
  }

  bool get hasChildren => widget.item.items.isNotEmpty;

  Color get _bgColor => isSelected && !hasChildren
      ? widget.selectedItemBackgroundColor ?? theme.colorScheme.primary
      : widget.rootBackgroundColor ?? Colors.transparent;

  Widget get _icon {
    final icon = widget.item.icon(isSelected);
    if (icon is Icon && icon.color == null) {
      return Icon(
        icon.icon,
        size: icon.size,
        fill: icon.fill,
        grade: icon.grade,
        weight: icon.weight,
        opticalSize: icon.opticalSize,
        semanticLabel: icon.semanticLabel,
        shadows: icon.shadows,
        color: MdToolkit.I.getColorInverted(_bgColor),
      );
    } else if (icon is MdIcn && icon.color == null) {
      return icon.copyWith(
        color: MdToolkit.I.getColorInverted(_bgColor),
      );
    }
    return icon;
  }

  Widget get _buildItem {
    return IntrinsicWidth(
      child: Container(
        width: !widget.isDense ? widget.item.width : widget.item.height,
        height: widget.item.height,
        alignment: Alignment.center,
        padding: widget.item.padding ??
            const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: widget.item.borderRadius ?? BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _icon,
            if (!widget.isDense) ...[
              const MdWidth(12),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: MdToolkit.I.getColorInverted(_bgColor),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
            if (hasChildren) const MdWidth(4),
            if (hasChildren)
              Icon(
                !isOpen
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_up_rounded,
                color: MdToolkit.I.getColorInverted(_bgColor).withOpacity(.8),
              )
          ],
        ),
      ),
    );
  }

  List<Widget> get _children => widget.item.items
      .map(
        (e) => Padding(
          padding: const EdgeInsets.only(left: 8),
          child: MdDrawerMenuItem(
            item: e,
            selectedItemKey: widget.selectedItemKey,
            isOpen: false,
            selectedItemBackgroundColor: widget.selectedItemBackgroundColor,
            rootBackgroundColor: widget.rootBackgroundColor,
            isDense: widget.isDense,
          ),
        ),
      )
      .toList();

  void _findChildrenOfTypeAndUnselect(Element element) {
    element.visitChildren((child) {
      if (child is StatefulElement && child.state is _MdDrawerMenuItemState) {
        final state = child.state as _MdDrawerMenuItemState;
        state.isSelected = false;
      }
      _findChildrenOfTypeAndUnselect(child);
    });
  }

  void _openAll() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.visitAncestorElements((e) {
        if (e is StatefulElement) {
          if (e.state is _MdDrawerMenuItemState) {
            final state = e.state as _MdDrawerMenuItemState;
            if (state.hasChildren) {
              state.isOpen = true;
            }
            return true;
          } else if (e.state is _MdDrawerState) {
            return false;
          }
        }
        return true;
      });
    });
  }

  void _unselectAll() {
    context.visitAncestorElements((e) {
      if (e is StatefulElement && e.state is _MdDrawerState) {
        _findChildrenOfTypeAndUnselect(e);
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: widget.item.borderRadius ?? BorderRadius.circular(6),
      onTap: () {
        if (hasChildren) {
          isOpen = !isOpen;
          widget.item.onOpen?.call();
        } else {
          _unselectAll();
          isSelected = !isSelected;
          widget.item.onRedirect?.call();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildItem,
          Visibility(
            visible: isOpen,
            maintainState: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _children,
            ),
          )
        ],
      ),
    );
  }

  @override
  List<MdStateObs> get observables => [
        () => isOpen,
        () => isSelected,
      ];
}
