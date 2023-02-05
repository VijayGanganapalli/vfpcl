import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/widgets/custom_text_field.dart';

class UploadItemsScreen extends StatefulWidget {
  const UploadItemsScreen({Key? key}) : super(key: key);

  @override
  State<UploadItemsScreen> createState() => _UploadItemsScreenState();
}

class _UploadItemsScreenState extends State<UploadItemsScreen> {
  Uint8List? imageFile;
  bool isUploading = false;
  TextEditingController sellerNameTextEditingController =
      TextEditingController();
  TextEditingController sellerPhoneTextEditingController =
      TextEditingController();
  TextEditingController itemNameTextEditingController = TextEditingController();
  TextEditingController itemDescriptionTextEditingController =
      TextEditingController();
  TextEditingController itemPriceTextEditingController =
      TextEditingController();

  // upload form screen
  Widget uploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload new item"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.cloud_upload_outlined),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            isUploading == true
                ? const CircularProgressIndicator()
                : Container(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(imageFile!))
                      : const Icon(Icons.image, size: 120, color: greyColor),
                ),
              ),
            ),
            Divider(thickness: 1, color: greyColor.withOpacity(0.2)),
            CustomTextField(
              prefixIcon: Icons.person_pin_rounded,
              controller: sellerNameTextEditingController,
              hintText: "Seller name",
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
            ),
            Divider(thickness: 1, color: greyColor.withOpacity(0.2)),
            CustomTextField(
              textCapitalization: TextCapitalization.none,
              prefixIcon: Icons.phone_iphone_rounded,
              controller: sellerPhoneTextEditingController,
              hintText: "Seller phone",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            Divider(thickness: 1, color: greyColor.withOpacity(0.2)),
            CustomTextField(
              prefixIcon: Icons.title_rounded,
              controller: itemNameTextEditingController,
              hintText: "Item name",
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
            ),
            Divider(thickness: 1, color: greyColor.withOpacity(0.2)),
            CustomTextField(
              prefixIcon: Icons.description,
              controller: itemDescriptionTextEditingController,
              hintText: "Item description",
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
            ),
            Divider(thickness: 1, color: greyColor.withOpacity(0.2)),
            CustomTextField(
              prefixIcon: Icons.currency_rupee_rounded,
              controller: itemPriceTextEditingController,
              hintText: "Item price",
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
            ),
            Divider(thickness: 1, color: greyColor.withOpacity(0.2)),
          ],
        ),
      ),
    );
  }

  // default screen for upload new item
  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload new item"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate,
              color: greyColor,
              size: 200,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
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
                                final pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                if (pickedImage != null) {
                                  //String imagePath = pickedImage.path;
                                  imageFile = await pickedImage.readAsBytes();
                                  // remove background from image
                                  // make image transparent
                                  setState(() {
                                    imageFile;
                                  });
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                }
                              } catch (error) {
                                setState(() {
                                  imageFile = null;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Icon(Icons.camera, color: primaryColor),
                                ),
                                Text(
                                  "Capture from camera",
                                  style: Theme.of(context).textTheme.bodyText1,
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              try {
                                final pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  //String imagePath = pickedImage.path;
                                  imageFile = await pickedImage.readAsBytes();
                                  // remove background from image
                                  // make image transparent
                                  setState(() {
                                    imageFile;
                                  });
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                }
                              } catch (error) {
                                setState(() {
                                  imageFile = null;
                                });
                              }
                            },
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
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: backgroundColor,
              ),
              child: Text(
                "Add new item picture",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null ? defaultScreen() : uploadFormScreen();
  }
}
