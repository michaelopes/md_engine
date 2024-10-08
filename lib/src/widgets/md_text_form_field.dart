// ignore_for_file: no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/base/md_state.dart';
import '../core/util/md_debouncer.dart';

class MdTextAreaFormField extends MdTextFormField {
  const MdTextAreaFormField({
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
  final Key? wdKey;
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

  const MdTextFormField({
    super.key,
    this.wdKey,
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
  }) : assert(
          textCleaner && controller != null ||
              !textCleaner && controller == null ||
              !textCleaner && controller != null,
          "Need a controller to use with textCleaner",
        );

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
      labelStyle: theme.inputDecorationTheme.labelStyle,
      hintStyle: theme.inputDecorationTheme.hintStyle,
      border: theme.inputDecorationTheme.border,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      errorBorder: theme.inputDecorationTheme.errorBorder,
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      disabledBorder: theme.inputDecorationTheme.disabledBorder,
      errorStyle: theme.inputDecorationTheme.errorStyle,
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
          Text(
            widget.labelText ?? "",
            style: theme.inputDecorationTheme.labelStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(
            height: 4,
          )
        ],
        TextFormField(
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
    _setup();
    super.didUpdateWidget(oldWidget);
    //_setup();
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(4),
              border: _hasFocus || _errorMessage != null
                  ? Border.all(
                      color: _errorMessage == null
                          ? theme.inputDecorationTheme.focusedBorder?.borderSide
                                  .color ??
                              theme.colorScheme.primary
                          : theme.colorScheme.error,
                      width: 1,
                    )
                  : Border.all(
                      color: theme.inputDecorationTheme.outlineBorder?.color ??
                          (widget.outlineBorderColor ?? Colors.transparent),
                    ),
            ),
            child: Row(
              children: [
                if (_prefixIcon != null) _prefixIcon!,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: _withCustomPadding ? 12 : 8,
                      bottom: _withCustomPadding ? 0 : 8,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: TextTheme(
                          titleMedium: theme.textTheme.titleMedium?.copyWith(
                            color: !widget.enabled
                                ? theme.textTheme.titleMedium?.color
                                    ?.withOpacity(.6)
                                : null,
                          ),
                        ),
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              error: _bgColor,
                            ),
                      ),
                      child: TextFormField(
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
                        obscureText: widget.obscureText && !_passwordVisibile,
                        enabled: widget.enabled,
                        onChanged: (value) {
                          _checkShowCleaner();
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
          if (_errorMessage != null) ...[
            Row(
              children: [
                const SizedBox(
                  height: 8,
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
                const SizedBox(
                  width: 6,
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
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: theme.inputDecorationTheme.labelStyle,
      labelStyle: theme.inputDecorationTheme.labelStyle,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.expandedHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(4),
            border: _hasFocus || _errorMessage != null
                ? Border.all(
                    color: _errorMessage == null
                        ? theme.inputDecorationTheme.focusedBorder?.borderSide
                                .color ??
                            theme.colorScheme.primary
                        : theme.inputDecorationTheme.errorBorder?.borderSide
                                .color ??
                            theme.colorScheme.error,
                    width: 1,
                  )
                : Border.all(
                    color: theme.inputDecorationTheme.outlineBorder?.color ??
                        (widget.outlineBorderColor ?? Colors.transparent),
                  ),
          ),
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
                        titleMedium: theme.textTheme.titleMedium?.copyWith(
                          color: !widget.enabled
                              ? theme.textTheme.titleMedium?.color
                                  ?.withOpacity(.6)
                              : null,
                        ),
                      ),
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            error: _bgColor,
                          ),
                    ),
                    child: TextFormField(
                      style: widget.enabled
                          ? null
                          : TextStyle(
                              color: theme.colorScheme.onSecondary,
                            ),
                      textAlignVertical: TextAlignVertical.top,
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      maxLength: widget.maxLength,
                      key: widget.wdKey,
                      inputFormatters: widget.inputFormatters,
                      focusNode: _focusNode,
                      decoration: _inputDecoration,
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
        if (_errorMessage != null) ...[
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.warning,
                size: 12,
                color: theme.inputDecorationTheme.errorStyle?.color,
              ),
              const SizedBox(
                width: 10,
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
