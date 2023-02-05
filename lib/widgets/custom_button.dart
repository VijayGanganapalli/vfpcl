import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool outlineButton;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.outlineButton,
    required this.onPressed,
    this.isLoading = false,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOutlineButton = outlineButton;
    bool isBtnLoading = isLoading;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isOutlineButton ? Colors.transparent : primaryColor,
          border: Border.all(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 4,
        ),
        padding: padding,
        child: Stack(
          children: [
            Visibility(
              visible: isBtnLoading ? false : true,
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: outlineButton ? primaryColor : Colors.white,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: isOutlineButton ? primaryColor : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
