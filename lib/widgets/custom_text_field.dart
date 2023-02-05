import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? mandatorySymbol;
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLength;
  final String? counterText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final String? initialValue;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Color? fillColor;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final Color? cursorColor;

  const CustomTextField(
      {Key? key,
      this.controller,
      required this.hintText,
      this.prefixIcon,
      this.textInputAction,
      this.keyboardType,
      this.obscureText,
      this.maxLength,
      this.counterText,
      this.validator,
      this.onChanged,
      this.onFieldSubmitted,
      this.focusNode,
      this.initialValue,
      this.onTap,
      this.onEditingComplete,
      this.fillColor,
      this.autovalidateMode,
      required this.textCapitalization,
      this.cursorColor,
      this.mandatorySymbol = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(prefixIcon, color: defaultColor),
          ),
          Text(
            mandatorySymbol!,
            style: const TextStyle(color: errorColor),
          ),
        ],
      ),
      title: SizedBox(
        child: TextField(
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          cursorColor: defaultColor,
          style: const TextStyle(color: defaultColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: greyColor,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
