import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdDashboardCard<T extends num> extends MdStateless {
  MdDashboardCard({
    super.key,
    this.backgroundColor,
    this.borderRadius,
    this.formater,
    required this.value,
    required this.title,
    this.icon,
    this.cardFooter,
    this.valueTextStyle,
  });

  final MdTextFormater? formater;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final String title;
  final T value;
  final Widget? icon;
  final TextStyle? valueTextStyle;
  final Widget? cardFooter;

  Color get _bgColor {
    return backgroundColor ?? theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 140),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: MdToolkit.I.getColorInverted(_bgColor),
              fontWeight: FontWeight.w700,
            ),
          ),
          const MdHeight(4),
          Divider(
            color: MdToolkit.I.getColorInverted(_bgColor).withOpacity(.3),
          ),
          const MdHeight(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MdCounterIndicator<T>(
                  start: (T == int ? 0 : 0.0) as T,
                  end: value,
                  formater: formater,
                  duration: const Duration(seconds: 1),
                  textStyle: valueTextStyle ??
                      theme.textTheme.headlineLarge?.copyWith(
                        color: MdToolkit.I.getColorInverted(_bgColor),
                        fontWeight: FontWeight.w700,
                        fontSize: 42,
                      ),
                ),
              ),
              const MdWidth(8),
              if (icon != null) icon!,
            ],
          ),
          if (cardFooter != null) cardFooter!,
        ],
      ),
    );
  }
}
