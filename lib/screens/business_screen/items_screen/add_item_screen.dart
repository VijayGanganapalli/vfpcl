import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vfpcl/widgets/border_dropdown.dart';
import 'package:vfpcl/widgets/border_form_field.dart';

import '../../../constants/colors.dart';
import '../../../constants/units.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _addItemFormKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemCategoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();

  String? _itemUnit;
  File? _productImageFile;

  String getUnit() {
    if (_itemUnit == null) {
      return "unit";
    } else {
      return _itemUnit.toString();
    }
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    _cropImage(pickedFile!.path);
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    _cropImage(pickedFile!.path);
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        _productImageFile = File(croppedImage.path);
      });
    } else {
      _productImageFile = null;
    }
  }

  clear() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            stretch: true,
            title: Text(
              "Add item",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _itemNameController.clear();
                  _itemCategoryController.clear();
                  _quantityController.clear();
                  _purchasePriceController.clear();
                  _salePriceController.clear();

                  setState(() {
                    _itemUnit = null;
                    _productImageFile = null;
                  });
                },
                icon: const Icon(Icons.clear),
              ),
              IconButton(
                onPressed: () {
                  if (_addItemFormKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _addItemFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BorderFormField(
                      controller: _itemNameController,
                      lableText: 'Item name *',
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid name"
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    BorderFormField(
                      controller: _itemCategoryController,
                      lableText: 'Item category',
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid name"
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    BorderDropdown(
                      hintText: "Select unit *",
                      value: _itemUnit,
                      items: Units().weightUnits.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        _itemUnit = null;
                        setState(() {
                          _itemUnit = value;
                        });
                      },
                      validator: (String? value) {
                        return _itemUnit == null ? "Please select unit" : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    BorderFormField(
                      controller: _quantityController,
                      lableText: "Quantity",
                      obscureText: false,
                      maxLength: 4,
                      counterText: "",
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'^\d+$').hasMatch(value))
                            ? "Please enter valid quantity"
                            : null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Price details per ${getUnit().toLowerCase()}",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 16),
                    BorderFormField(
                      controller: _purchasePriceController,
                      lableText: 'Purchase price *',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'^\d*(\.\d{2})?$').hasMatch(value))
                            ? "Please enter valid rate"
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    BorderFormField(
                      controller: _salePriceController,
                      lableText: 'Sale price *',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'^\d*(\.\d{2})?$').hasMatch(value))
                            ? "Please enter valid rate"
                            : null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Item image",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        height: 250,
                        width: 200,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _productImageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _productImageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Please choose an option",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                _getFromCamera();
                                              },
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons.camera,
                                                        color: primaryColor),
                                                  ),
                                                  Text(
                                                    "Capture from camera",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  )
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                _getFromGallery();
                                              },
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons.image,
                                                        color: primaryColor),
                                                  ),
                                                  Text(
                                                    "Select from gallery",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
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
                                child: Icon(
                                  Icons.add_photo_alternate,
                                  size: 120,
                                  color: greyColor.withOpacity(0.4),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
