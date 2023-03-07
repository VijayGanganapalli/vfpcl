import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

class BorderDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

  const BorderDropdown(
      {Key? key,
      this.items,
      this.onChanged,
      required this.hintText,
      this.value,
      this.validator,
      this.autovalidateMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: Text(
        hintText,
      ),
      value: value,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      ),
      validator: validator,
      autovalidateMode: autovalidateMode,
      items: items,
      onChanged: onChanged,
    );
  }
}
