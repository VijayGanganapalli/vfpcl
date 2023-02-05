import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

Future<void> alertDialogBuilder(BuildContext context, String error) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Alert",
          style: Theme.of(context).textTheme.headline2,
        ),
        content: Text(
          error,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: [
          TextButton(
            child: Text(
              "Close",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
