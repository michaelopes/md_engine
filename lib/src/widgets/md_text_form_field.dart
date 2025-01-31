// ignore_for_file: no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../md_engine.dart';

class MdTextAreaFormField extends MdTextFormField {
  MdTextAreaFormField({
    super.key,
    super.wdKey,
    super.inputFormatters,
    super.helperText,
    super.hintText,
    super.labelText,
    super.fillColor,
    super.textColor,
    super.outlineBorderColor,
    super.onChanged,
    super.onClearTap,
    super.controller,
    super.keyboardType,
    super.validator,
    super.autoFocus = false,
    super.enabled = true,
    super.obscureText = false,
    super.obscureShowIcon,
    super.obscureHideIcon,
    super.enableInteractiveSelection = true,
    super.textInputAction,
    super.prefixIcon,
    super.focusNode,
    super.topLabel = true,
    super.lines = 1,
    super.maxLength,
    super.onFieldSubmitted,
    super.suffixIcon,
    super.validateOnType = false,
    super.textCapitalization = TextCapitalization.none,
    super.textCleaner = false,
    super.expandedHeight = 156,
  }) : assert(
          textCleaner && controller != null ||
              !textCleaner && controller == null ||
              !textCleaner && controller != null,
          "Need a controller to use with textCleaner",
        );

  @override
  State<MdTextFormField> createState() => _MdTextFormFieldExpandedState();
}

class MdTextFormField extends StatefulWidget {
  final String? hintText;
  final String? helperText;
  final String? labelText;
  final bool obscureText;
  final Widget? obscureShowIcon;
  final Widget? obscureHideIcon;
  final bool enabled;
  final Color? fillColor;
  final Color? textColor;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final bool autoFocus;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enableInteractiveSelection;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final FocusNode? focusNode;

  final List<TextInputFormatter>? inputFormatters;
  final bool topLabel;
  final int lines;
  final int? maxLength;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool validateOnType;

  final TextCapitalization textCapitalization;
  final bool textCleaner;
  final double? expandedHeight;
  final VoidCallback? onClearTap;
  final Color? outlineBorderColor;

  late final Key? wdKey;

  MdTextFormField({
    super.key,
    Key? wdKey,
    this.inputFormatters,
    this.helperText,
    this.hintText,
    this.labelText,
    this.fillColor,
    this.textColor,
    this.outlineBorderColor,
    this.onChanged,
    this.onClearTap,
    this.controller,
    this.keyboardType,
    this.validator,
    this.autoFocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.obscureShowIcon,
    this.obscureHideIcon,
    this.enableInteractiveSelection = true,
    this.textInputAction,
    this.prefixIcon,
    this.focusNode,
    this.topLabel = true,
    this.lines = 1,
    this.maxLength,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.validateOnType = false,
    this.textCapitalization = TextCapitalization.none,
    this.textCleaner = false,
    this.expandedHeight = 156,
  }) {
    assert(
      textCleaner && controller != null ||
          !textCleaner && controller == null ||
          !textCleaner && controller != null,
      "Need a controller to use with textCleaner",
    );
    this.wdKey = wdKey ?? UniqueKey();
  }

  @override
  State<MdTextFormField> createState() =>
      _MdTextFormFieldBackgroundFloatLabelState();
}

class _MdTextFormFieldState extends MdState<MdTextFormField> {
  bool _passwordVisibile = false;
  bool _showCleaner = false;

  @override
  void initState() {
    super.initState();
    _passwordVisibile = !widget.obscureText;
    widget.controller?.addListener(() {
      _checkShowCleaner();
    });
  }

  InputDecoration get _baseInputDecoration {
    return InputDecoration(
      hintText: widget.hintText ?? "",
      helperText: widget.helperText,
      labelText: widget.topLabel ? null : widget.labelText,
      fillColor: widget.fillColor,
      labelStyle: theme.inputDecorationTheme.labelStyle?.copyWith(height: 1) ??
          const TextStyle(height: 1),
      hintStyle: theme.inputDecorationTheme.hintStyle,
      border: theme.inputDecorationTheme.border,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      errorBorder: theme.inputDecorationTheme.errorBorder,
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      disabledBorder: theme.inputDecorationTheme.disabledBorder,
      focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
      errorStyle: const TextStyle(height: 0, fontSize: 0.001),
      hoverColor: Colors.transparent,
    );
  }

  Widget get _passwordSuffixIcon {
    final Widget iconToUse;
    if (_passwordVisibile) {
      iconToUse = widget.obscureShowIcon ??
          Icon(
            Icons.visibility,
            size: 20,
            color: theme.inputDecorationTheme.suffixIconColor ??
                Theme.of(context).inputDecorationTheme.suffixIconColor,
          );
    } else {
      iconToUse = widget.obscureHideIcon ??
          Icon(
            Icons.visibility_off,
            size: 20,
            color: theme.inputDecorationTheme.suffixIconColor ??
                Theme.of(context).inputDecorationTheme.suffixIconColor,
          );
    }

    return Visibility(
      visible: widget.obscureText,
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            setState(() {
              _passwordVisibile = !_passwordVisibile;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: iconToUse,
        ),
      ),
    );
  }

  void _checkShowCleaner() {
    if (mounted) {
      if (widget.textCleaner) {
        if ((widget.controller?.text ?? "").isNotEmpty) {
          if (mounted) {
            setState(() => _showCleaner = true);
          }
        } else if (_showCleaner) {
          if (mounted) {
            setState(() => _showCleaner = false);
          }
        }
      }
    }
  }

  Widget get _textCleanerSufixIcon {
    return Visibility(
      visible: widget.textCleaner && _showCleaner,
      child: GestureDetector(
        onTap: () {
          widget.controller?.text = "";
          widget.onClearTap?.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.close,
            size: 20,
            color: theme.inputDecorationTheme.suffixIconColor,
          ),
        ),
      ),
    );
  }

  Widget? get _prefixIcon {
    return widget.prefixIcon != null
        ? Theme(
            data: theme.copyWith(
                iconTheme: IconThemeData(
                    color: theme.inputDecorationTheme.prefixIconColor)),
            child: Container(
                margin: const EdgeInsets.only(left: 8),
                width: 22,
                child: widget.prefixIcon!),
          )
        : null;
  }

  Widget? get _suffixIcon {
    Widget? suffix;

    if (widget.suffixIcon != null) {
      suffix = Theme(
        data: theme.copyWith(
            iconTheme: IconThemeData(
                color: theme.inputDecorationTheme.suffixIconColor)),
        child: widget.suffixIcon!,
      );
    } else if (widget.textCleaner) {
      suffix = _textCleanerSufixIcon;
    } else {
      suffix = _passwordSuffixIcon;
    }
    return suffix;
  }

  InputDecoration get _inputDecoration {
    return _baseInputDecoration.copyWith(
      suffixIcon: _suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.topLabel) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.labelText ?? "",
              style: theme.inputDecorationTheme.labelStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        TextFormField(
          style: TextStyle(
            color: theme.inputDecorationTheme.fillColor != null &&
                    theme.inputDecorationTheme.filled
                ? MdToolkit.I
                    .getColorInverted(theme.inputDecorationTheme.fillColor!)
                : null,
          ),
          minLines: widget.lines,
          maxLines: widget.lines,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          key: widget.wdKey,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          decoration: _inputDecoration,
          validator: widget.validator,
          obscureText: widget.obscureText && !_passwordVisibile,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          controller: widget.controller,
          autofocus: widget.autoFocus,
          keyboardType: widget.keyboardType,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
      ],
    );
  }
}

class _MdTextFormFieldBackgroundFloatLabelState extends _MdTextFormFieldState {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  late final _deboucer = MdDebouncer(
    duration: const Duration(milliseconds: 1800),
    onValue: _validateField,
  );

  bool _hasFocus = false;
  bool _isControllerListenerTrigged = false;
  @override
  void initState() {
    _setup();
    super.initState();
    // _setup();
  }

  void _setup() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.removeListener(_focusNodeListener);

    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      if (!_isControllerListenerTrigged) {
        if (mounted) {
          setState(() {});
        }
        _isControllerListenerTrigged = true;
      }
    });
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.unfocus();
      setState(() {
        _hasFocus = false;
      });
    });
    super.reassemble();
  }

  void _focusNodeListener() {
    if (mounted) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  @override
  InputDecoration get _inputDecoration {
    return _baseInputDecoration.copyWith(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0, horizontal: 12).copyWith(
        top: 4,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      label: widget.labelText != null
          ? Text(
              widget.labelText ?? "",
              style: theme.inputDecorationTheme.labelStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          : null,
    );
  }

  String? _errorMessage;

  Color? get _bgColor => theme.inputDecorationTheme.fillColor;

  bool get _withCustomPadding =>
      (_hasFocus || _controller.text.isNotEmpty) &&
      widget.labelText != null &&
      widget.labelText!.isNotEmpty;

  void _validateField(value) {
    if (mounted) {
      setState(() {
        _errorMessage = widget.validator?.call(value);
      });
    }
  }

  BorderRadius get _borderRadius {
    if (!widget.enabled) {
      if (super._baseInputDecoration.disabledBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.disabledBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (_hasFocus && (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.focusedBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.focusedBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (!_hasFocus &&
        (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.enabledBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.enabledBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (!_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.errorBorder?.isOutline ?? false) {
        final b = super._baseInputDecoration.errorBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.focusedErrorBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.focusedErrorBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else {
      if (super._baseInputDecoration.border?.isOutline ?? false) {
        final b = super._baseInputDecoration.border as OutlineInputBorder;
        return b.borderRadius;
      }
    }

    return BorderRadius.circular(4);
  }

  Color get _borderColor {
    if (!widget.enabled) {
      if (super._baseInputDecoration.disabledBorder != null) {
        final b = super._baseInputDecoration.disabledBorder!;
        return b.borderSide.color;
      }
    } else if (_hasFocus && (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.focusedBorder != null) {
        final b = super._baseInputDecoration.focusedBorder!;
        return b.borderSide.color;
      }
    } else if (!_hasFocus &&
        (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.enabledBorder != null) {
        final b = super._baseInputDecoration.enabledBorder!;
        return b.borderSide.color;
      }
    } else if (!_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.errorBorder != null) {
        final b = super._baseInputDecoration.errorBorder!;
        return b.borderSide.color;
      }
    } else if (_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.focusedErrorBorder != null) {
        final b = super._baseInputDecoration.focusedErrorBorder!;
        return b.borderSide.color;
      }
    } else {
      if (super._baseInputDecoration.border != null) {
        final b = super._baseInputDecoration.border!;
        return b.borderSide.color;
      }
    }

    return theme.colorScheme.primary;
  }

  double get _borderWidth {
    if (!widget.enabled) {
      if (super._baseInputDecoration.disabledBorder != null) {
        final b = super._baseInputDecoration.disabledBorder!;
        return b.borderSide.width;
      }
    } else if (_hasFocus && (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.focusedBorder != null) {
        final b = super._baseInputDecoration.focusedBorder!;
        return b.borderSide.width;
      }
    } else if (!_hasFocus &&
        (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.enabledBorder != null) {
        final b = super._baseInputDecoration.enabledBorder!;
        return b.borderSide.width;
      }
    } else if (!_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.errorBorder != null) {
        final b = super._baseInputDecoration.errorBorder!;
        return b.borderSide.width;
      }
    } else if (_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.focusedErrorBorder != null) {
        final b = super._baseInputDecoration.focusedErrorBorder!;
        return b.borderSide.width;
      }
    } else {
      if (super._baseInputDecoration.border != null) {
        final b = super._baseInputDecoration.border!;
        return b.borderSide.width;
      }
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = theme.inputDecorationTheme.fillColor != null &&
            theme.inputDecorationTheme.filled
        ? MdToolkit.I.getColorInverted(theme.inputDecorationTheme.fillColor!)
        : null;

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: kDefaultMdTextFormFieldHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: _borderRadius,
              border: Border.all(
                color: _borderColor,
                width: _borderWidth,
              ),
            ),
            child: ClipRRect(
              borderRadius: _borderRadius,
              child: Row(
                children: [
                  if (_prefixIcon != null) _prefixIcon!,
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: _withCustomPadding ? 9 : 4,
                          bottom: _withCustomPadding ? 0 : 4,
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: TextTheme(
                              bodyLarge: theme.textTheme.bodyLarge?.copyWith(
                                decoration: TextDecoration.none,
                                color: !widget.enabled
                                    ? textColor?.withOpacity(.95)
                                    : textColor?.withOpacity(.6),
                              ),
                            ),
                          ),
                          child: TextFormField(
                            style: theme.textTheme.bodyLarge,
                            textAlignVertical: TextAlignVertical.top,
                            minLines: widget.lines,
                            maxLines: widget.lines,
                            maxLength: widget.maxLength,
                            key: widget.wdKey,
                            textCapitalization: widget.textCapitalization,
                            inputFormatters: widget.inputFormatters,
                            focusNode: _focusNode,
                            decoration: _inputDecoration,
                            validator: (value) {
                              _validateField(value);
                              return _errorMessage == null ? null : "";
                            },
                            obscureText:
                                widget.obscureText && !_passwordVisibile,
                            enabled: widget.enabled,
                            onChanged: (_) {
                              _checkShowCleaner();
                              if (widget.validateOnType) {
                                _deboucer.value = _controller.text;
                              }
                              widget.onChanged?.call(_controller.text);
                            },
                            controller: _controller,
                            autofocus: widget.autoFocus,
                            keyboardType: widget.keyboardType,
                            enableInteractiveSelection:
                                widget.enableInteractiveSelection,
                            textInputAction: widget.textInputAction,
                            onFieldSubmitted: widget.onFieldSubmitted,
                            // cursorHeight: 16.0,
                            //cursorWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_suffixIcon != null) _suffixIcon!
                ],
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            Row(
              children: [
                const SizedBox(
                  height: 2,
                ),
                SizedBox(
                  height: 22,
                  width: 22,
                  child: Icon(
                    Icons.warning,
                    size: 12,
                    color: theme.inputDecorationTheme.errorStyle?.color,
                  ),
                ),
                Expanded(
                  child: Text(
                    _errorMessage ?? "",
                    overflow: TextOverflow.fade,
                    style: theme.inputDecorationTheme.errorStyle,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class _MdTextFormFieldExpandedState extends _MdTextFormFieldState {
  late final _focusNode = widget.focusNode ?? FocusNode();
  late final _controller = widget.controller ?? TextEditingController();

  late final _deboucer = MdDebouncer(
    duration: const Duration(milliseconds: 800),
    onValue: _validateField,
  );

  bool _hasFocus = false;
  @override
  void initState() {
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _hasFocus = _focusNode.hasFocus;
        });
      }
    });
    super.initState();
  }

  @override
  InputDecoration get _inputDecoration {
    return _baseInputDecoration.copyWith(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: theme.inputDecorationTheme.labelStyle,
      labelStyle: theme.inputDecorationTheme.labelStyle,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12)
          .copyWith(top: 4),
      label: widget.labelText != null
          ? Text(
              widget.labelText ?? "",
              style:
                  theme.inputDecorationTheme.labelStyle?.copyWith(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          : null,
    );
  }

  BorderRadius get _borderRadius {
    if (!widget.enabled) {
      if (super._baseInputDecoration.disabledBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.disabledBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (_hasFocus && (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.focusedBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.focusedBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (!_hasFocus &&
        (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.enabledBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.enabledBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (!_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.errorBorder?.isOutline ?? false) {
        final b = super._baseInputDecoration.errorBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else if (_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.focusedErrorBorder?.isOutline ?? false) {
        final b =
            super._baseInputDecoration.focusedErrorBorder as OutlineInputBorder;
        return b.borderRadius;
      }
    } else {
      if (super._baseInputDecoration.border?.isOutline ?? false) {
        final b = super._baseInputDecoration.border as OutlineInputBorder;
        return b.borderRadius;
      }
    }

    return BorderRadius.circular(4);
  }

  Color get _borderColor {
    if (!widget.enabled) {
      if (super._baseInputDecoration.disabledBorder != null) {
        final b = super._baseInputDecoration.disabledBorder!;
        return b.borderSide.color;
      }
    } else if (_hasFocus && (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.focusedBorder != null) {
        final b = super._baseInputDecoration.focusedBorder!;
        return b.borderSide.color;
      }
    } else if (!_hasFocus &&
        (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.enabledBorder != null) {
        final b = super._baseInputDecoration.enabledBorder!;
        return b.borderSide.color;
      }
    } else if (!_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.errorBorder != null) {
        final b = super._baseInputDecoration.errorBorder!;
        return b.borderSide.color;
      }
    } else if (_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.focusedErrorBorder != null) {
        final b = super._baseInputDecoration.focusedErrorBorder!;
        return b.borderSide.color;
      }
    } else {
      if (super._baseInputDecoration.border != null) {
        final b = super._baseInputDecoration.border!;
        return b.borderSide.color;
      }
    }

    return theme.colorScheme.primary;
  }

  double get _borderWidth {
    if (!widget.enabled) {
      if (super._baseInputDecoration.disabledBorder != null) {
        final b = super._baseInputDecoration.disabledBorder!;
        return b.borderSide.width;
      }
    } else if (_hasFocus && (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.focusedBorder != null) {
        final b = super._baseInputDecoration.focusedBorder!;
        return b.borderSide.width;
      }
    } else if (!_hasFocus &&
        (_errorMessage == null || _errorMessage!.isEmpty)) {
      if (super._baseInputDecoration.enabledBorder != null) {
        final b = super._baseInputDecoration.enabledBorder!;
        return b.borderSide.width;
      }
    } else if (!_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.errorBorder != null) {
        final b = super._baseInputDecoration.errorBorder!;
        return b.borderSide.width;
      }
    } else if (_hasFocus &&
        (_errorMessage != null || _errorMessage!.isNotEmpty)) {
      if (super._baseInputDecoration.focusedErrorBorder != null) {
        final b = super._baseInputDecoration.focusedErrorBorder!;
        return b.borderSide.width;
      }
    } else {
      if (super._baseInputDecoration.border != null) {
        final b = super._baseInputDecoration.border!;
        return b.borderSide.width;
      }
    }

    return 1;
  }

  String? _errorMessage;

  Color? get _bgColor => theme.inputDecorationTheme.fillColor;

  void _validateField(value) {
    if (mounted) {
      setState(() {
        _errorMessage = widget.validator?.call(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = theme.inputDecorationTheme.fillColor != null &&
            theme.inputDecorationTheme.filled
        ? MdToolkit.I.getColorInverted(theme.inputDecorationTheme.fillColor!)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.expandedHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: _borderRadius,
            border: Border.all(
              color: _borderColor,
              width: _borderWidth,
            ),
          ),
          child: ClipRRect(
            borderRadius: _borderRadius,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                      bottom: 8,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: TextTheme(
                          bodyLarge: theme.textTheme.bodyLarge?.copyWith(
                            decoration: TextDecoration.none,
                            color: !widget.enabled
                                ? textColor?.withOpacity(.8)
                                : textColor?.withOpacity(.38),
                          ),
                        ),
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              error: _bgColor,
                            ),
                      ),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        maxLength: widget.maxLength,
                        key: widget.wdKey,
                        inputFormatters: widget.inputFormatters,
                        focusNode: _focusNode,
                        validator: (value) {
                          _validateField(value);
                          return _errorMessage == null ? null : "";
                        },
                        obscureText: widget.obscureText && !_passwordVisibile,
                        enabled: widget.enabled,
                        onChanged: (value) {
                          if (widget.validateOnType) {
                            _deboucer.value = value;
                          }
                          widget.onChanged?.call(value);
                        },
                        controller: _controller,
                        autofocus: widget.autoFocus,
                        keyboardType: widget.keyboardType,
                        enableInteractiveSelection:
                            widget.enableInteractiveSelection,
                        textInputAction: widget.textInputAction,
                        onFieldSubmitted: widget.onFieldSubmitted,
                      ),
                    ),
                  ),
                ),
                if (_suffixIcon != null) _suffixIcon!
              ],
            ),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Icon(
                Icons.warning,
                size: 12,
                color: theme.inputDecorationTheme.errorStyle?.color,
              ),
              Text(
                _errorMessage ?? "",
                style: theme.inputDecorationTheme.errorStyle,
              ),
            ],
          ),
        ]
      ],
    );
  }
}
