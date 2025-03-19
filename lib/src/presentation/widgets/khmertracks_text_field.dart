import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KhmertracksTextField extends StatelessWidget {
  const KhmertracksTextField({
    super.key,
    this.labelText = '',
    this.labelWidget,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.readOnly = false,
    this.minLine = 1,
    this.maxLine = 1,
    this.maxLength,
    this.focusNode,
    this.hintText,
    this.initialValue,
    this.autofocus = false,
    this.onTap,
    this.controller,
    this.prefixText,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.outlineInputBorder = true,
    this.fillColor,
    this.borderRadius = 12.0,
    this.enabled = true,
  });

  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final Widget? labelWidget;
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int minLine;
  final int maxLine;
  final bool autofocus;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool outlineInputBorder;
  final Color? fillColor;
  final double borderRadius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      initialValue: initialValue,
      controller: controller,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      readOnly: readOnly,
      minLines: minLine,
      maxLength: maxLength,
      autofocus: autofocus,
      focusNode: focusNode,
      maxLines: maxLine,
      enabled: enabled,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ??
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        floatingLabelBehavior: floatingLabelBehavior,
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
        counterText: '',
        suffixIcon: suffixIcon,
        prefixText: prefixText,
        prefixIcon: prefixIcon,
        prefixIconConstraints:
            const BoxConstraints(minWidth: 48, maxHeight: 48),
        suffixIconConstraints:
            const BoxConstraints(minWidth: 48, maxHeight: 48),
      ),
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
