import 'package:flutter/material.dart';
import '../core/base/md_state.dart';

class MdFailureMoreDetails extends StatefulWidget {
  const MdFailureMoreDetails({super.key, required this.message});
  final String message;
  @override
  State<MdFailureMoreDetails> createState() => _MdFailureMoreDetailsState();
}

class _MdFailureMoreDetailsState extends MdState<MdFailureMoreDetails> {
  var visibility = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              visibility = !visibility;
            });
          },
          child: Text(
            visibility ? "Ver menos" : "Ver mais",
            style: TextStyle(
              color: theme.dialogTheme.backgroundColor,
            ),
          ),
        ),
        Container(
          color: Colors.grey.shade200,
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: visibility ? 280 : 0),
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
