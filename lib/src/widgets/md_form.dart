import 'package:flutter/material.dart';

class MdForm extends StatefulWidget {
  const MdForm({
    super.key,
    this.scrollController,
    required this.child,
  });

  final ScrollController? scrollController;

  final Widget child;

  @override
  State<MdForm> createState() => MdFormState();
}

class MdFormState extends State<MdForm> {
  final _formKey = GlobalKey<FormState>();

  final _fields = <StatefulElement>[];

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(covariant MdForm oldWidget) {
    if (widget != oldWidget) {
      _setup();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fields.clear();
      _registerFields(context);
    });
  }

  void _registerFields(BuildContext parentElement) {
    if (mounted) {
      parentElement.visitChildElements((element) {
        if (element is StatefulElement) {
          if (element.state is FormFieldState) {
            _fields.add(element);
          } else {
            _registerFields(element);
          }
        } else {
          _registerFields(element);
        }
      });
    }
  }

  void reset() {
    _formKey.currentState?.reset();
  }

  void save() {
    _formKey.currentState?.save();
  }

  bool validate() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final scrollController = widget.scrollController;
    if (!isValid && scrollController != null) {
      for (var element in _fields) {
        final state = element.state;
        if (state is FormFieldState) {
          if (!state.isValid) {
            final RenderBox renderBox = element.renderObject as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            scrollController.animateTo(
              position.dx, // Posição X desejada
              duration: Duration(milliseconds: 500), // Duração da animação
              curve: Curves.easeInOut, // Curva da animação
            );
            break;
          }
        }
      }
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.child,
    );
  }
}
