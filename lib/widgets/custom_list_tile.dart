import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final void Function()? onTap;
  const CustomListTile({Key? key, this.title, this.leading, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: greyColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        leading: leading,
        title: Text(title!),
        onTap: onTap,
      ),
    );
  }
}
