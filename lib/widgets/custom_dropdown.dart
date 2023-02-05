import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

class CustomDropdown extends StatelessWidget {
  final String? title;
  final String mandatorySymbol;
  final String hintText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

  const CustomDropdown(
      {Key? key,
      this.title,
      required this.mandatorySymbol,
      this.items,
      this.onChanged,
      required this.hintText,
      this.value,
      this.validator,
      this.autovalidateMode})
      : super(key: key);

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
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            hint: Text(
              hintText,
              style: TextStyle(
                color: greyColor.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: greyColor.withOpacity(0.1),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            ),
            validator: validator,
            autovalidateMode: autovalidateMode,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
