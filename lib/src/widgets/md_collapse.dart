import 'package:flutter/material.dart';
import 'package:md_engine/src/core/base/md_state.dart';

typedef ExpandedChildBuilder = Future<Widget> Function();

class MdCollapse extends StatefulWidget {
  const MdCollapse({
    super.key,
    this.child,
    this.title,
    this.fixedDivider = false,
    this.expandedChildBuilder,
    this.customTitle,
    this.backgroundColor,
    this.onBackgroundColor,
    this.expanded = false,
  });
  final String? title;
  final Widget? customTitle;
  final Widget? child;
  final bool fixedDivider;
  final ExpandedChildBuilder? expandedChildBuilder;
  final bool expanded;

  final Color? backgroundColor;
  final Color? onBackgroundColor;

  @override
  State<MdCollapse> createState() => _MdCollapseState();
}

class _MdCollapseState extends MdState<MdCollapse> {
  bool _expanded = false;
  late Widget child;
  bool _inLoading = false;
  double _turns = 0;
  @override
  void initState() {
    child = widget.child ?? const SizedBox.shrink();
    _expanded = widget.expanded;
    super.initState();
  }

  Future<void> _builder() async {
    if (widget.expandedChildBuilder != null && !_inLoading) {
      setState(() {
        child = const SizedBox(
          height: 80,
          child: Center(
            child: UnconstrainedBox(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        );
      });
      var wd = await widget.expandedChildBuilder!();
      setState(() {
        child = wd;
      });
      _inLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Column(
        children: [
          ListTileTheme(
            contentPadding: const EdgeInsets.only(left: 20),
            dense: true,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            child: ExpansionTile(
              onExpansionChanged: (value) {
                if (value) {
                  _builder();
                }
                setState(() {
                  _expanded = value;
                  _turns = value ? .5 : 0;
                });
              },
              trailing: Container(
                width: 0,
              ),
              backgroundColor:
                  widget.backgroundColor ?? theme.colorScheme.background,
              collapsedBackgroundColor:
                  widget.backgroundColor ?? theme.colorScheme.background,
              iconColor:
                  widget.onBackgroundColor ?? theme.colorScheme.onBackground,
              collapsedIconColor:
                  widget.onBackgroundColor ?? theme.colorScheme.onBackground,
              leading: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 250),
                  turns: _turns,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: widget.onBackgroundColor ??
                        theme.colorScheme.onBackground.withOpacity(.9),
                  ),
                ),
              ),
              title: widget.customTitle ??
                  Text(
                    (widget.title ?? ""),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: widget.onBackgroundColor ??
                          theme.colorScheme.onBackground,
                    ),
                  ),
              children: [
                DefaultTextStyle.merge(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.onBackgroundColor ??
                        theme.colorScheme.onBackground,
                  ),
                  child: child,
                )
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.fixedDivider
                ? 1
                : !_expanded
                    ? 0
                    : 1,
            child: Container(
              height: .5,
              //margin: const EdgeInsets.only(top: 8),
              color: theme.dividerColor,
            ),
          )
        ],
      ),
    );
  }
}
