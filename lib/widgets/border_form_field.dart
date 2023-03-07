import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

class BorderFormField extends StatelessWidget {
  final Widget? icon;
  final String? lableText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final String? counterText;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Color? fillColor;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final bool? enabled;
  final bool? autofocus;
  final bool? readOnly;

  const BorderFormField({
    Key? key,
    this.icon,
    this.lableText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.controller,
    this.onTap,
    this.textInputAction,
    this.maxLength,
    this.counterText,
    this.focusNode,
    this.initialValue,
    this.suffixIcon,
    this.onEditingComplete,
    required this.obscureText,
    this.fillColor,
    this.autovalidateMode,
    required this.textCapitalization,
    this.enabled,
    this.autofocus = false,
    this.readOnly = false,
    required this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly!,
      autofocus: autofocus!,
      enabled: enabled,
      textInputAction: textInputAction,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      initialValue: initialValue,
      autovalidateMode: autovalidateMode,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      decoration: InputDecoration(
        icon: icon,
        suffixIcon: suffixIcon,
        labelText: lableText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: errorColor),
          borderRadius: BorderRadius.circular(8),
        ),
        counterText: counterText,
      ),
      validator: validator,

      //style: fieldsText,
      controller: controller,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
