import 'package:flutter/material.dart';

class MdCardObserver extends StatefulWidget {
  const MdCardObserver({
    super.key,
    required this.listener,
    required this.builder,
  });

  final ChangeNotifier listener;
  final WidgetBuilder builder;

  @override
  State<MdCardObserver> createState() => _MdCardObserverState();
}

class _MdCardObserverState extends State<MdCardObserver> {
  @override
  void initState() {
    widget.listener.addListener(_listener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MdCardObserver oldWidget) {
    if (oldWidget.hashCode != widget.hashCode) {
      widget.listener.removeListener(_listener);
      widget.listener.addListener(_listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _listener() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
