import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom text form field widget with optional microphone input
class TextFormWidget extends StatelessWidget {
  final String title;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Color? iconColor;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final bool required;
  final bool? readOnly;
  final bool? autofocus;
  final bool? enableMic;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool? suffixIconTrue;
  final IconData? suffixIcon;
  final String? suffixText;
  final String? prefixText;
  final VoidCallback? suffixIconOnPressed;
  final String? helperText;
  final String? errorText;
  final TextStyle? helperStyle;
  final bool? obscureText;
  final bool? enabled;
  final String? obscuringCharacter;
  final String? counterText;
  final int? errorMaxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final InputDecoration? decoration;

  const TextFormWidget({
    super.key,
    required this.title,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.iconColor,
    this.controller,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    required this.required,
    this.readOnly,
    this.autofocus,
    this.onTap,
    this.inputFormatters,
    this.suffixIconTrue,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.suffixIconOnPressed,
    this.helperText,
    this.errorText,
    this.helperStyle,
    this.obscureText,
    this.enabled,
    this.obscuringCharacter,
    this.counterText,
    this.errorMaxLines,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.initialValue,
    this.textCapitalization,
    this.maxLines,
    this.decoration,
    this.enableMic = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the title with an asterisk if the field is required
        RichText(
          text: TextSpan(
            text: title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: "tamilFont",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          maxLines: maxLines ?? 1,
          // minLines: 1,
          initialValue: initialValue,
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: textInputAction ?? TextInputAction.next,
          maxLength: maxLength,
          obscureText: obscureText ?? false,
          scrollPadding: EdgeInsets.zero,
          obscuringCharacter: obscuringCharacter ?? '*',
          autofocus: autofocus ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          readOnly: readOnly ?? false,
          enabled: enabled,
          onSaved: onSaved,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.clip,
          ),
          decoration: decoration ?? customDecoration(context),
        ),
      ],
    );
  }

  /// Returns a custom decoration for the text form field
  InputDecoration customDecoration(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      prefixText: prefixText,
      hintText: hintText ?? title,
      counterText: counterText ?? '',
      errorMaxLines: errorMaxLines ?? 1,
      helperText: helperText,
      alignLabelWithHint: true,
      filled: readOnly == true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.all(13.0),
      isDense: true,
      suffixIconConstraints: const BoxConstraints(minWidth: 5, minHeight: 2),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 20, color: colorScheme.primary)
          : null,
      prefixIconConstraints: const BoxConstraints(minHeight: 30, minWidth: 40),
      suffixIcon: getSuffix(controller, context),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        overflow: TextOverflow.clip,
        color: Colors.grey.shade700,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xffD2D2D2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xffD2D2D2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: BorderSide(color: colorScheme.primary),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xffD2D2D2)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  /// Returns the appropriate suffix widget for the text form field
  Widget? getSuffix(TextEditingController? ctrl, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (suffixIconTrue == true) {
      return SizedBox(
        height: 25,
        width: 40,
        child: IconButton(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          icon: Icon(suffixIcon, size: 22, color: colorScheme.primary),
          onPressed: suffixIconOnPressed,
        ),
      );
    }

    return null;
  }
}
