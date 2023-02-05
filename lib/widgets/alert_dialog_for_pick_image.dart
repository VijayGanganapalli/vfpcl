import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vfpcl/constants/colors.dart';

Future<dynamic> alertDialogForPickImage(
    BuildContext context, Uint8List? imageFile) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Please choose an option",
          style: Theme.of(context).textTheme.headline2,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                try {
                  final pickedImage =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    String imagePath = pickedImage.path;
                    imageFile = await pickedImage.readAsBytes();
                    // remove background from image
                    // make image transparent
                  }
                } catch (error) {}
              },
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.camera, color: primaryColor),
                  ),
                  Text(
                    "Capture from camera",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.image, color: primaryColor),
                  ),
                  Text(
                    "Select from gallery",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
