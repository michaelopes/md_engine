import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdAlert extends MdStateless {
  final String message;
  final String? title;
  final AlertType type;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  MdAlert({
    super.key,
    required this.message,
    this.title,
    this.type = AlertType.info,
    this.dismissible = false,
    this.onDismiss,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case AlertType.success:
        backgroundColor = Colors.green;
        textColor = MdToolkit.I.generateHighlightColor(Colors.green);
        icon = Icons.check_circle;
        break;
      case AlertType.warning:
        backgroundColor = Colors.orange;
        textColor = MdToolkit.I.generateHighlightColor(Colors.orange);
        icon = Icons.warning;
        break;
      case AlertType.danger:
        backgroundColor = Colors.red;
        textColor = MdToolkit.I.generateHighlightColor(Colors.red);
        icon = Icons.error;
        break;
      case AlertType.info:
      default:
        backgroundColor = Colors.blue;
        textColor = MdToolkit.I.generateHighlightColor(Colors.blue);
        icon = Icons.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(
        right: dismissible ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4.0),
      ),
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(4.0),
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Icon(icon, color: textColor),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textColor,
                        ),
                        children: [
                          if (title != null && title!.isNotEmpty)
                            TextSpan(
                              text: "$title: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          TextSpan(
                            text: message,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (dismissible)
                InkWell(
                  onTap: onDismiss,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Icon(Icons.close, color: textColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AlertType {
  success,
  warning,
  danger,
  info,
}
