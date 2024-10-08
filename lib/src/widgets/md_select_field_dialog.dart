import 'package:flutter/material.dart';

import '../core/base/md_state.dart';
import 'md_appbar.dart';
import 'md_container.dart';
import 'md_height.dart';
import 'md_list_no_items_found.dart';
import 'md_text_form_field.dart';
import 'md_width.dart';

class MdSelectFieldDialogItem {
  final dynamic key;
  final String text;
  final Widget? leading;

  MdSelectFieldDialogItem({
    this.key,
    required this.text,
    this.leading,
  });
}

class MdSelectFieldDialog extends StatefulWidget {
  const MdSelectFieldDialog({
    super.key,
    required this.selectedIndex,
    this.labelText,
    required this.items,
    this.onChanged,
    this.borderRadius,
    this.noItemsFound,
  });

  final List<MdSelectFieldDialogItem> items;
  final int selectedIndex;
  final Function(MdSelectFieldDialogItem item)? onChanged;
  final double? borderRadius;
  final String? labelText;
  final WidgetBuilder? noItemsFound;

  @override
  State<MdSelectFieldDialog> createState() => _MdSelectFieldDialogState();
}

class _MdSelectFieldDialogState extends MdState<MdSelectFieldDialog> {
  late MdSelectFieldDialogItem _selectedItem;

  final _searchBy = ValueNotifier("");

  InputDecorationTheme get _wThem => theme.inputDecorationTheme;

  @override
  void initState() {
    super.initState();
    if (widget.items.asMap().containsKey(widget.selectedIndex)) {
      _selectedItem = widget.items[widget.selectedIndex];
    } else {
      _selectedItem = widget.items.first;
    }
  }

  @override
  void didUpdateWidget(covariant MdSelectFieldDialog oldWidget) {
    if (widget.items.asMap().containsKey(widget.selectedIndex)) {
      _selectedItem = widget.items[widget.selectedIndex];
    } else {
      _selectedItem = widget.items.first;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var text = Text(
      _selectedItem.text,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyLarge,
    );
    return GestureDetector(
      onTap: () {
        if (widget.items.isNotEmpty) _openSearch();
      },
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _wThem.fillColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
        ),
        child: Row(
          children: [
            if (_selectedItem.leading != null) ...[
              _selectedItem.leading!,
              const MdWidth(12),
            ] else
              const MdWidth(12),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (widget.labelText != null &&
                        widget.labelText!.isNotEmpty)
                      Positioned(
                        top: 8,
                        child: Text(
                          widget.labelText!,
                          style: _wThem.labelStyle,
                        ),
                      ),
                    widget.labelText != null && widget.labelText!.isNotEmpty
                        ? Positioned(top: 26, child: text)
                        : text,
                  ],
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: _wThem.suffixIconColor,
            ),
            const MdWidth(12),
          ],
        ),
      ),
    );
  }

  Widget get _buildSearchSection {
    return MdContainer(
      top: 24,
      child: Row(
        children: [
          Expanded(
            child: MdTextFormField(
              labelText: tr.shared.search(),
              validateOnType: true,
              onChanged: (val) => {
                setState(() {
                  _searchBy.value = val;
                }),
              },
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSearch() async {
    _searchBy.value = "";
    var result = await showDialog(
      context: context,
      builder: (_) {
        return Dialog.fullscreen(
          backgroundColor: theme.colorScheme.background,
          child: Scaffold(
            appBar: MdAppBar(),
            body: Column(
              children: [
                _buildSearchSection,
                const MdHeight(16),
                ValueListenableBuilder(
                  valueListenable: _searchBy,
                  builder: (_, value, ___) {
                    return Expanded(
                      child: _filtredItems.isEmpty
                          ? widget.noItemsFound?.call(context) ??
                              MdListNoItemsFound()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ListView(
                                children: _filtredItems
                                    .map((e) => _buildItem(e))
                                    .toList(),
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _selectedItem = result;
      });
      widget.onChanged?.call(_selectedItem);
    }
  }

  Widget _buildItem(MdSelectFieldDialogItem item) {
    return ListTile(
      leading: item.leading,
      title: Text(
        item.text,
        style: TextStyle(color: theme.colorScheme.onBackground),
      ),
      onTap: () {
        Navigator.of(context).pop(item);
      },
    );
  }

  List<MdSelectFieldDialogItem> get _filtredItems => (widget.items
      .where(
        (e) =>
            (e.text.toLowerCase().contains(_searchBy.value.toLowerCase())) ||
            _searchBy.value.isEmpty,
      )
      .toList()
    ..sort((a, b) => a.text.toLowerCase().compareTo(a.text)));
}
