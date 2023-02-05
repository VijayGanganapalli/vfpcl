import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

class CustomFormField extends StatelessWidget {
  final String? title;
  final String mandatorySymbol;
  final Widget? icon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final String? counterText;
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

  const CustomFormField({
    Key? key,
    this.title,
    required this.mandatorySymbol,
    this.icon,
    this.hintText,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  mandatorySymbol,
                  style: const TextStyle(color: errorColor),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
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
          decoration: InputDecoration(
            icon: icon,
            filled: true,
            suffixIcon: suffixIcon,
            fillColor: fillColor,
            hintText: hintText,
            hintStyle: TextStyle(
              color: greyColor.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
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
        ),
      ],
    );
  }
}
