import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class MdSubRouteBuilder extends StatefulWidget {
  const MdSubRouteBuilder({
    super.key,
    required this.router,
  });

  final QRouter router;

  @override
  State<MdSubRouteBuilder> createState() => _MdSubRouteBuilderState();
}

class _MdSubRouteBuilderState extends State<MdSubRouteBuilder> {
  @override
  void initState() {
    widget.router.navigator.addListener(_update);
    super.initState();
  }

  void _update() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.router.navigator.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.router;
  }
}
