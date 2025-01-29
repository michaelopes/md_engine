import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:md_engine/md_engine.dart';

class MdSearchDialog<T> extends StatefulWidget {
  const MdSearchDialog({
    super.key,
    this.noItemsEmptyState,
    this.indicador,
    this.label,
    this.inputFormatters,
    this.validator,
    this.pageSize = 20,
    required this.firstPageKey,
    required this.fetchItems,
    required this.itemBuilder,
  });

  final WidgetBuilder? noItemsEmptyState;
  final WidgetBuilder? indicador;
  final String? label;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final int firstPageKey;
  final int pageSize;
  final Future<List<T>> Function(String term, int pageKey, int pageSize)
      fetchItems;
  final Widget Function(T item, int index) itemBuilder;

  Future<dynamic> show(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      builder: (_) => this,
      barrierDismissible: barrierDismissible,
      useSafeArea: false,
      useRootNavigator: true,
      barrierColor: barrierColor ??
          MdToolkit.I
              .getColorInverted(
                Theme.of(context).colorScheme.surface,
              )
              .withOpacity(.35),
    );
  }

  @override
  State<MdSearchDialog<T>> createState() => _MdSearchDialogState<T>();
}

class _MdSearchDialogState<T> extends MdState<MdSearchDialog<T>> {
  late final _pagingController =
      PagingController<int, T>(firstPageKey: widget.firstPageKey);

  final _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final _deboucer = MdDebouncer(
    duration: Duration(milliseconds: 800),
    onValue: _search,
  );

  Future<void> _search(value) async {
    if (_formKey.currentState?.validate() ?? false) {
      _pagingController.refresh();
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var term = _searchController.text.trim();
      final newItems = await widget.fetchItems(
        term,
        pageKey,
        widget.pageSize,
      );
      if (mounted) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      final isLastPage = newItems.length < widget.pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  final _focusNode = FocusNode();

  final _hasText = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: MdContainer(
            top: 32,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: MdTextFormField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    labelText: widget.label ?? tr.shared.search(),
                    inputFormatters: widget.inputFormatters,
                    validator: widget.validator,
                    onChanged: (value) {
                      _hasText.value = value.isNotEmpty;
                      _deboucer.value = value;
                    },
                    prefixIcon: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    suffixIcon: ValueListenableBuilder(
                        valueListenable: _hasText,
                        builder: (_, __, ___) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _hasText.value
                                ? InkWell(
                                    onTap: () {
                                      _searchController.text = "";
                                      _pagingController.refresh();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _hasText.value = false;
                                    },
                                    child: Icon(Icons.close),
                                  )
                                : Icon(Icons.search),
                          );
                        }),
                  ),
                ),
                MdHeight(24),
                Expanded(
                  child: PagedListView(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<T>(
                      firstPageErrorIndicatorBuilder: (_) =>
                          widget.noItemsEmptyState?.call(context) ??
                          MdListNoItemsFound(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                      noItemsFoundIndicatorBuilder: (_) =>
                          widget.noItemsEmptyState?.call(context) ??
                          MdListNoItemsFound(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                      newPageErrorIndicatorBuilder: (_) =>
                          widget.noItemsEmptyState?.call(context) ??
                          MdListNoItemsFound(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                      noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
                      firstPageProgressIndicatorBuilder: (_) => Center(
                        child: widget.indicador?.call(context) ??
                            CircularProgressIndicator.adaptive(),
                      ),
                      itemBuilder: (context, item, index) {
                        return widget.itemBuilder(item, index);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
