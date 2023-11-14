import "package:flutter/material.dart";
import "package:flutter/services.dart";

import 'theme.couver_theme.dart';
import 'comp.c_input_border.dart';
import '../utils/debonce.dart';
import 'buttons/widget.c_button.dart';
import 'buttons/widget.c_icon_button.dart';

extension InputBorderExt on InputBorder {
  InputBorder copyColor(Color color) {
    return copyWith(
      borderSide: borderSide.copyWith(color: color),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class CTextFormField extends StatefulWidget {
  const CTextFormField({
    Key? key,
    this.clearable = false,
    this.clearableText,
    this.password = false,
    this.passwordToggle = true,
    this.showCounter = false,
    this.showDropdown,
    this.debounce,
    this.noDebounceOnEmpty = true,
    this.margin,
    // -------For Input-----------------
    this.controller,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter,
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength = 250,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    // -------For input decoration------
    this.icon,
    this.iconColor,
    this.label,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.hintText,
    this.hintStyle,
    this.hintTextDirection,
    this.hintMaxLines,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.floatingLabelBehavior,
    this.floatingLabelAlignment,
    this.isCollapsed = false,
    this.isDense,
    this.contentPadding,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefix,
    this.prefixText,
    this.prefixStyle,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconColor,
    this.suffixIconConstraints,
    this.counter,
    this.counterText,
    this.counterStyle,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border,
    // this.enabled = true,
    this.semanticCounterText,
    this.alignLabelWithHint,
    this.constraints,
    this.mustClickEdit = false,
    this.onTapEdit,
    this.loading = false,
    this.showRequired = false,
    this.showOptional = false,
    // ------------
  })  : _outlined = false,
        useOutlinePadding = false,
        super(key: key);

  const CTextFormField.outlined({
    Key? key,
    this.clearable = false,
    this.clearableText,
    this.password = false,
    this.passwordToggle = true,
    this.showCounter = false,
    this.showDropdown,
    this.debounce,
    this.noDebounceOnEmpty = true,
    this.margin,
    this.useOutlinePadding = true,
    // -------For Input-----------------
    this.controller,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter,
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength = 250,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    // -------For input decoration------
    this.icon,
    this.iconColor,
    this.label,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.hintText,
    this.hintStyle,
    this.hintTextDirection,
    this.hintMaxLines,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.floatingLabelBehavior,
    this.floatingLabelAlignment,
    this.isCollapsed = false,
    this.isDense,
    this.contentPadding,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefix,
    this.prefixText,
    this.prefixStyle,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconColor,
    this.suffixIconConstraints,
    this.counter,
    this.counterText,
    this.counterStyle,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border,
    // this.enabled = true,
    this.semanticCounterText,
    this.alignLabelWithHint,
    this.constraints,
    this.mustClickEdit = false,
    this.onTapEdit,
    this.loading = false,
    this.showRequired = false,
    this.showOptional = false,
    // ------------
  })  : _outlined = true,
        super(key: key);

  // ------Custom fields --------

  /// Determine for outline if
  final bool useOutlinePadding;

  /// Add a clear button at the end
  final bool clearable;

  final String? clearableText;

  /// Require click icon to edit
  final bool mustClickEdit;

  /// Add a loading icon at the end and disable the input
  final bool loading;

  /// Only effective when [mustClickEdit] is enabled
  final GestureTapCallback? onTapEdit;

  // -------------------For input-----------------------

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  // final InputDecoration? decoration = const InputDecoration();
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String? obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;

  // -------------------End input-----------------------

  // ---------------------from Official InputDecoration-------------------

  /// An icon to show before the input field and outside of the decoration's
  /// container.

  final Widget? icon;

  /// The color of the [icon].
  final Color? iconColor;

  /// Optional widget that describes the input field.
  final Widget? label;

  /// Optional text that describes the input field.
  final String? labelText;

  /// The style to use for [InputDecoration.labelText] when the label is on top
  /// of the input field.
  final TextStyle? labelStyle;

  /// The style to use for [InputDecoration.labelText] when the label is
  /// above (i.e., vertically adjacent to) the input field.
  final TextStyle? floatingLabelStyle;

  /// Text that provides context about the [InputDecorator.child]'s value, such
  /// as how the value will be used.
  final String? helperText;

  /// The style to use for the [helperText].
  final TextStyle? helperStyle;

  /// The maximum number of lines the [helperText] can occupy.
  final int? helperMaxLines;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// The style to use for the [hintText].
  final TextStyle? hintStyle;

  /// The direction to use for the [hintText].
  final TextDirection? hintTextDirection;

  /// The maximum number of lines the [hintText] can occupy.
  final int? hintMaxLines;

  /// Text that appears below the [InputDecorator.child] and the border.
  final String? errorText;

  /// The style to use for the [InputDecoration.errorText].
  final TextStyle? errorStyle;

  /// The maximum number of lines the [errorText] can occupy.
  final int? errorMaxLines;

  /// Defines **how** the floating label should behave.
  final FloatingLabelBehavior? floatingLabelBehavior;

  /// Defines **where** the floating label should be displayed.
  final FloatingLabelAlignment? floatingLabelAlignment;

  /// Whether the [InputDecorator.child] is part of a dense form (i.e., uses less vertical
  final bool? isDense;

  /// The padding for the input decoration's container.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the decoration is the same size as the input field.
  final bool isCollapsed;

  /// An icon that appears before the [prefix] or [prefixText] and before
  final Widget? prefixIcon;

  /// The constraints for the prefix icon.
  final BoxConstraints? prefixIconConstraints;

  /// Optional widget to place on the line before the input.
  final Widget? prefix;

  /// Optional text prefix to place on the line before the input.
  final String? prefixText;

  /// The style to use for the [prefixText].
  final TextStyle? prefixStyle;

  /// Optional color of the prefixIcon
  final Color? prefixIconColor;

  /// An icon that appears after the editable part of the text field and
  /// after the [suffix] or [suffixText], within the decoration's container.
  final Widget? suffixIcon;

  /// Optional widget to place on the line after the input.
  final Widget? suffix;

  /// Optional text suffix to place on the line after the input.
  final String? suffixText;

  /// The style to use for the [suffixText].
  final TextStyle? suffixStyle;

  /// Optional color of the suffixIcon
  final Color? suffixIconColor;

  /// The constraints for the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// Optional text to place below the line as a character count.
  final String? counterText;

  /// Optional custom counter widget to go in the place otherwise occupied by
  /// [counterText].  If this property is non null, then [counterText] is
  /// ignored.
  final Widget? counter;

  /// The style to use for the [counterText].
  final TextStyle? counterStyle;

  /// If true the decoration's container is filled with [fillColor].
  final bool? filled;

  /// The base fill color of the decoration's container color.
  final Color? fillColor;

  /// By default the [focusColor] is based on the current [Theme].
  final Color? focusColor;

  /// The color of the focus highlight for the decoration shown if the container
  final Color? hoverColor;

  /// The border to display when the [InputDecorator] does not have the focus and
  /// is showing an error.
  final InputBorder? errorBorder;

  /// The border to display when the [InputDecorator] has the focus and is not
  /// showing an error.
  final InputBorder? focusedBorder;

  /// The border to display when the [InputDecorator] has the focus and is
  /// showing an error.
  final InputBorder? focusedErrorBorder;

  /// The border to display when the [InputDecorator] is disabled and is not

  final InputBorder? disabledBorder;

  /// The border to display when the [InputDecorator] is enabled and is not
  /// showing an error.
  final InputBorder? enabledBorder;

  /// The shape of the border to draw around the decoration's container.
  final InputBorder? border;

  /// If false [helperText],[errorText], and [counterText] are not displayed,
  // final bool enabled;

  /// A semantic label for the [counterText].
  final String? semanticCounterText;

  /// Typically set to true when the [InputDecorator] contains a multiline
  final bool? alignLabelWithHint;

  /// Defines minimum and maximum sizes for the [InputDecorator].
  final BoxConstraints? constraints;

  // --------End of decoration-------------------------------------

  // final AutovalidateMode? autovalidateMode;

  /// Default to 200;
  // final int? maxLength;

  /// Give a obscureText and an eye toggle at the end
  final bool password;

  /// Only available when [password] is true
  final bool passwordToggle;

  /// Show wordcounts like '10/200'
  final bool showCounter;

  /// Add a dropdown icon at the end
  final bool? showDropdown;

  /// Debounce will change the behavior of onChanged
  final Duration? debounce;

  /// External padding
  final EdgeInsetsGeometry? margin;

  /// Ignor debounce when changed to empty
  final bool noDebounceOnEmpty;

  /// Gives a specific couver style
  final bool _outlined;

  /// Add a * at the end of labelText
  final bool showRequired;

  /// Add (Optional) at the end of labelText
  final bool showOptional;

  @override
  State<CTextFormField> createState() => _CTextFormFieldState();
}

class _CTextFormFieldState extends State<CTextFormField> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool passwordV = false;
  late Debounce? _debounce;
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  bool _hasValue = false;

  /// Must be enable to show the button
  bool get _canShowSuffixButton => (widget.enabled ?? true) && !widget.readOnly;

  /// Is true enabled?
  bool get trueEnabled => widget.enabled != false && widget.loading != true;

  bool get isEnabled => widget.enabled != false;

  AutovalidateMode? _autovalidateMode;

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  void _focusListener() {
    if (!_focusNode.hasFocus) {
      if (widget.autovalidateMode == null &&
          _autovalidateMode != AutovalidateMode.always) {
        setState(() {
          _autovalidateMode = AutovalidateMode.always;
        });
      }
      if (widget.mustClickEdit) {
        setState(() {
          _focusNode.canRequestFocus = false;
        });
      }
    }
  }

  void _onEditButtonTap() {
    if (widget.onTapEdit != null) {
      widget.onTapEdit?.call();
    } else {
      _focusNode.canRequestFocus = true;
      _focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    if (widget.debounce is Duration) {
      _debounce = Debounce(widget.debounce!);
    } else {
      _debounce = null;
    }

    if (widget.clearable) {
      _controller.addListener(() {
        _controllerListener();
      });
    }
    if (widget.controller?.text.isNotEmpty ?? false) {
      _hasValue = true;
    }
    final String initialVal = widget.initialValue ?? "";
    if (initialVal.isNotEmpty && _controller.text.isEmpty) {
      _controller.text = initialVal;
    }

    _focusNode.addListener(() => _focusListener());
    _autovalidateMode = widget.autovalidateMode ?? AutovalidateMode.disabled;
    super.initState();
    if (widget.mustClickEdit) {
      Future.delayed(Duration.zero, () {
        _focusNode.canRequestFocus = false;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      if (widget.clearable) {
        _controller.removeListener(() {
          _controllerListener();
        });
      }
    } else {
      if (widget.clearable) {
        _controller.dispose();
      }
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _debounce?.dispose();
    super.dispose();
  }

  void _controllerListener() {
    setState(() {
      _hasValue = _controller.text.isNotEmpty;
    });
  }

  void _onInputChanged(String e) {
    if (widget.onChanged != null) {
      if (_debounce == null || (e.isEmpty && widget.noDebounceOnEmpty)) {
        _debounce?.dispose();
        widget.onChanged!(e);
      } else {
        _debounce!(() {
          widget.onChanged!(e);
        });
      }
    }
  }

  void clearField() {
    _controller.clear();
    _onInputChanged("");
  }

  void _togglePasswordV() {
    setState(() {
      passwordV = !passwordV;
    });
  }

  Widget? getLabel() {
    if (widget.label != null) {
      return widget.label;
    }
    if (widget.labelText != null) {
      return Text(widget.labelText ?? "");
    }
    return null;
  }

  Widget? getSuffixIcon() {
    if (widget.loading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).disabledColor),
            ),
          ),
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    if (widget.mustClickEdit && !_focusNode.hasFocus && isEnabled) {
      return Padding(
        padding: const EdgeInsets.only(right: 4),
        child: CIconButton(
          onPressed: () => _onEditButtonTap(),
          icon: const Icon(Icons.edit_outlined),
        ),
      );
    }
    if (widget.password && widget.passwordToggle && _canShowSuffixButton) {
      return Padding(
        padding: const EdgeInsets.only(right: 4),
        child: CIconButton(
          onPressed: _togglePasswordV,
          icon: Icon(
            passwordV
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Theme.of(context).disabledColor,
          ),
        ),
      );
    }
    if (widget.clearable && _hasValue && _canShowSuffixButton) {
      if ((widget.clearableText ?? "").isNotEmpty) {
        return CButton(
          text: widget.clearableText,
          onPressed: clearField,
          size: BtnSize.xs.copyWith(
            padding: EdgeInsets.zero,
          ),
        );
      }
      return CButton.circle(
        onPressed: clearField,
        size: null,
        child: Icon(
          Icons.close_sharp,
          color: Theme.of(context).hintColor,
        ),
      );
    }
    if ((widget.showDropdown == null && widget.onTap != null) ||
        widget.showDropdown == true) {
      return Icon(
        Icons.expand_more,
        color: Theme.of(context).disabledColor,
      );
    }
    return null;
  }

  BoxConstraints? getSuffixIconConstraint() {
    if (widget.suffixIconConstraints != null) {
      return widget.suffixIconConstraints;
    }
    if ((!widget.password || widget.passwordToggle) && widget.clearable) {
      if (widget.isDense ?? false) {
        return const BoxConstraints(minWidth: 36, minHeight: 36);
      }
      return const BoxConstraints(minWidth: 46, minHeight: 46);
    }
    return null;
  }

  InputBorder _border(BuildContext context) {
    final double inputBorderRadius = CouverTheme.of(context).inputBorderRadius;
    if (widget.border != null) {
      return widget.border!;
    }
    if (widget._outlined) {
      return COutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
    );
  }

  TextInputType? getKeyboardType() {
    if (widget.keyboardType != null) {
      return widget.keyboardType;
    }
    if (widget.password) {
      return TextInputType.visiblePassword;
    }
    return null;
  }

  String? getCounterText() {
    if (widget.counterText != null) {
      return widget.counterText;
    }
    if (widget.showCounter) {
      return null;
    }
    return "";
  }

  EdgeInsetsGeometry? getContentPadding() {
    if (widget.contentPadding != null) {
      return widget.contentPadding;
    }

    if (widget._outlined) {
      if (widget.useOutlinePadding) {
        if (widget.label != null || widget.labelText != null) {
          if (widget.isDense == true) {
            return const EdgeInsets.fromLTRB(12, 8, 12, 8);
          }
          return const EdgeInsets.fromLTRB(12, 12, 12, 12);
        }
        if (widget.isDense == true) {
          return const EdgeInsets.fromLTRB(12, 16, 12, 16);
        }
        return const EdgeInsets.fromLTRB(12, 20, 12, 20);
      }
      if (widget.isDense == true) {
        return const EdgeInsets.fromLTRB(12, 8, 12, 8);
      }
      return const EdgeInsets.fromLTRB(12, 12, 12, 12);
    }
    return null;
  }

  InputDecoration? getInputDecoration(BuildContext context) {
    String? labelText = widget.labelText;
    if (labelText is String) {
      if (widget.showRequired) {
        labelText += "*";
      } else if (widget.showOptional) {
        labelText += ' (Optional)';
      }
    }
    final CouverThemeData cTheme = CouverTheme.of(context);

    return InputDecoration(
      icon: widget.icon,
      iconColor: widget.iconColor,
      label: widget.label,
      labelText: widget.label == null ? widget.labelText : null,
      labelStyle: widget.labelStyle,
      floatingLabelStyle: widget.floatingLabelStyle,
      helperText: widget.helperText,
      helperStyle: widget.helperStyle,
      helperMaxLines: widget.helperMaxLines,
      hintText: widget.hintText,
      hintStyle: widget.hintStyle,
      hintTextDirection: widget.hintTextDirection,
      hintMaxLines: widget.hintMaxLines,
      errorText: widget.errorText,
      errorStyle: widget.errorStyle,
      errorMaxLines: widget.errorMaxLines,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      floatingLabelAlignment: widget.floatingLabelAlignment,
      isCollapsed: widget.isCollapsed,
      isDense: widget.isDense,
      contentPadding: getContentPadding(),
      prefixIcon: widget.prefixIcon,
      prefixIconConstraints: widget.prefixIconConstraints,
      prefix: widget.prefix,
      prefixText: widget.prefixText,
      prefixStyle: widget.prefixStyle,
      prefixIconColor: widget.prefixIconColor,
      suffixIcon: getSuffixIcon(),
      suffix: widget.suffix,
      suffixText: widget.suffixText,
      suffixStyle: widget.suffixStyle,
      suffixIconColor: widget.suffixIconColor,
      suffixIconConstraints: getSuffixIconConstraint(),
      counter: widget.counter,
      counterText: getCounterText(),
      counterStyle: widget.counterStyle,
      filled: widget.filled ?? !isEnabled,
      fillColor: widget.fillColor ??
          (!isEnabled ? cTheme.colors.inputDisableFillColor : null),
      focusColor: widget.focusColor,
      focusedBorder: widget.focusedBorder, // _focusedBorder,
      hoverColor: widget.hoverColor,
      errorBorder: widget.errorBorder,
      // disabledBorder: widget.disabledBorder,
      disabledBorder: widget.disabledBorder ??
          _border(context).copyColor(cTheme.colors.inputDisableBorderColor),
      // enabledBorder: widget.enabledBorder,
      enabledBorder: widget.enabledBorder ??
          _border(context).copyColor(cTheme.colors.inputEnabledBorderColor),
      border: _border(context),
      enabled: isEnabled,
      semanticCounterText: widget.semanticCounterText,
      alignLabelWithHint: widget.alignLabelWithHint,
      constraints: widget.constraints,
    );
  }

  VoidCallback? get onTap {
    if (widget.mustClickEdit && !_focusNode.hasFocus) {
      return () => FocusManager.instance.primaryFocus?.unfocus();
    }
    return widget.onTap;
  }

  @override
  Widget build(BuildContext context) {
    final String obscuringCharacter =
        widget.obscuringCharacter ?? CouverTheme.of(context).obscuringCharacter;
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: CouverTheme.of(context).colors.inputFocusBorderColor,
          brightness: Theme.of(context).brightness,
        ),
      ),
      child: Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: getKeyboardType(),
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          style: widget.style,
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly || widget.loading,
          showCursor: widget.showCursor,
          obscuringCharacter: obscuringCharacter,
          obscureText: widget.obscureText || (widget.password && !passwordV),
          autocorrect: widget.autocorrect,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          maxLength: widget.maxLength,
          onChanged: _onInputChanged,
          onTap: onTap, //widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          onSaved: widget.onSaved,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          enabled: isEnabled,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorColor: widget.cursorColor,
          keyboardAppearance: widget.keyboardAppearance,
          scrollPadding: widget.scrollPadding,
          enableInteractiveSelection: widget.mustClickEdit
              ? _focusNode.canRequestFocus
              : widget.enableInteractiveSelection,
          selectionControls: widget.selectionControls,
          buildCounter: widget.buildCounter,
          scrollPhysics: widget.scrollPhysics,
          autofillHints: widget.autofillHints,
          autovalidateMode: _autovalidateMode,
          scrollController: widget.scrollController,
          restorationId: widget.restorationId,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          decoration: getInputDecoration(context),
        ),
      ),
    );
  }
}
