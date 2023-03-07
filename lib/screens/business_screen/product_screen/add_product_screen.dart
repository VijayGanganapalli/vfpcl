import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/constants/units.dart';

import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_form_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _addProductFormKey = GlobalKey<FormState>();

  File? productImageFile;
  String? productImgUrl;
  bool isUploading = false;
  String? unitController;
  DateTime selectedInvoiceDate = DateTime.now();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productCategoryController =
      TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController sellerNameController = TextEditingController();
  final TextEditingController sellerAddressController = TextEditingController();
  final TextEditingController sellerGstNumberController =
      TextEditingController();
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerAddressController = TextEditingController();
  final TextEditingController invoiceDateController = TextEditingController();
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController buyerGstNumberController =
      TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();

  final CollectionReference _productsRef = FirebaseFirestore.instance
      .collection("fpcs")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("products");

  String rateTitle() {
    if (unitController == null) {
      return "unit";
    } else {
      return unitController.toString();
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
        productImageFile = File(croppedImage.path);
      });
    } else {
      productImageFile = null;
    }
  }

  Future<String?> addProduct() async {
    final document = _productsRef.doc();
    final uid = document.id;
    final user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot productSnapshot = await _productsRef.get();

    var vInvoice = productSnapshot.docs.map((e) => e['invoiceNumber']);

    if (productImageFile == null) {
      if (!mounted) return null;
      alertDialogBuilder(context, "Please upload product image");
    } else if (vInvoice.any((element) =>
        element == int.parse(invoiceNumberController.text.trim()))) {
      if (!mounted) return null;
      alertDialogBuilder(context, "This invoice number already saved");
    } else {
      final productImgRef = FirebaseStorage.instance
          .ref()
          .child("productImages")
          .child("${user.email}")
          .child("$uid.jpg");
      await productImgRef.putFile(productImageFile!);
      productImgUrl = await productImgRef.getDownloadURL();
      await _productsRef.doc(uid).set({
        'productImgUrl': productImgUrl,
        'invoiceNumber': int.parse(invoiceNumberController.text.trim()),
        'invoiceDate':
            DateFormat("dd-MM-yyyy").parse(invoiceDateController.text.trim()),
        'productName': productNameController.text.trim(),
        'productCategory': productCategoryController.text.trim(),
        'unit': unitController!.trim(),
        'ratePerUnit': double.parse(rateController.text.trim()),
        'quantity': int.parse(quantityController.text.trim()),
        'sellerName': sellerNameController.text.trim(),
        'sellerAddress': sellerAddressController.text.trim(),
        'sellerGstNumber': sellerGstNumberController.text.trim(),
        'buyerName': buyerNameController.text.trim(),
        'buyerAddress': buyerAddressController.text.trim(),
        'buyerGstNumber': buyerGstNumberController.text.trim(),
        'vehicleNumber': vehicleNumberController.text.trim(),
      }).whenComplete(() async {
        setState(() {
          isUploading = false;
        });
        await alertDialogBuilder(context, "Product added successfully");
        if (!mounted) return;
        Navigator.pop(context);
      }).catchError((error) async {
        setState(() {
          isUploading = false;
        });
        await alertDialogBuilder(
            context, "You are not able to add product due to $error");
        if (!mounted) return;
        Navigator.pop(context);
      });
      return null;
    }
    return null;
  }

  void _submitForm() async {
    setState(() {
      isUploading = true;
    });
    String? loginAccountFeedback = await addProduct();
    setState(() {
      isUploading = false;
    });
    if (loginAccountFeedback != null) {
      if (!mounted) return;
      alertDialogBuilder(context, loginAccountFeedback);
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    productCategoryController.dispose();
    rateController.dispose();
    quantityController.dispose();
    sellerNameController.dispose();
    sellerAddressController.dispose();
    sellerGstNumberController.dispose();
    buyerNameController.dispose();
    buyerAddressController.dispose();
    invoiceDateController.dispose();
    invoiceNumberController.dispose();
    buyerGstNumberController.dispose();
    vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            stretch: true,
            title: Text(
              "Add Product",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    if (_addProductFormKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  icon: isUploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _addProductFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 240,
                        width: 200,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: productImageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  productImageFile!,
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
                    CustomFormField(
                      controller: invoiceNumberController,
                      mandatorySymbol: "*",
                      title: "Invoice number",
                      hintText: "Enter invoice number",
                      obscureText: false,
                      maxLength: 10,
                      counterText: "",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'^\d+$').hasMatch(value))
                            ? "Please enter valid invoice number"
                            : null;
                      },
                    ),
                    CustomFormField(
                      readOnly: true,
                      autofocus: false,
                      controller: invoiceDateController,
                      mandatorySymbol: "*",
                      title: "Invoice date",
                      hintText: invoiceDateController.text.isEmpty
                          ? "Select invoice date"
                          : invoiceDateController.text,
                      suffixIcon: const Icon(Icons.calendar_month),
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedInvoiceDate,
                          firstDate: DateTime(2022, 10),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null &&
                            pickedDate != selectedInvoiceDate) {
                          setState(() {
                            selectedInvoiceDate = pickedDate;
                            invoiceDateController.text =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][\d-]+$').hasMatch(value))
                            ? "Please select valid invoice date"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: productNameController,
                      mandatorySymbol: "*",
                      title: "Name of product",
                      hintText: "Enter product name",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid name"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: productCategoryController,
                      mandatorySymbol: "*",
                      title: "Category of product",
                      hintText: "Enter product category",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid category"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "Unit",
                      mandatorySymbol: "*",
                      hintText: "Select unit",
                      value: unitController,
                      items: Units().weightUnits.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        unitController = null;
                        setState(() {
                          unitController = value;
                        });
                      },
                      validator: (String? value) {
                        return unitController == null
                            ? "Please select unit"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: rateController,
                      mandatorySymbol: "*",
                      title: "Rate per ${rateTitle().toLowerCase()}",
                      hintText: "Enter rate per unit",
                      obscureText: false,
                      maxLength: 8,
                      counterText: "",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'^\d*(\.\d{2})?$').hasMatch(value))
                            ? "Please enter valid rate"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: quantityController,
                      mandatorySymbol: "*",
                      title: "Quantity",
                      hintText: "Enter no of units",
                      obscureText: false,
                      maxLength: 4,
                      counterText: "",
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
                    CustomFormField(
                      controller: sellerNameController,
                      mandatorySymbol: "*",
                      title: 'Name of seller',
                      hintText: 'Enter seller name',
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid name"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: sellerAddressController,
                      mandatorySymbol: "*",
                      title: 'Seller address',
                      hintText: 'Enter seller address',
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z.\d]+$')
                                    .hasMatch(value))
                            ? "Please enter valid address"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: sellerGstNumberController,
                      mandatorySymbol: "",
                      title: "Seller GST number",
                      hintText: "Enter seller GST number",
                      maxLength: 15,
                      counterText: "",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      /*validator: (String? value) {
                        return (value!.isEmpty ||
                                    !RegExp(r'[^-\s][A-Z\d]+$')
                                        .hasMatch(value)) ||
                                value.length != 15
                            ? "Please enter valid GST number"
                            : null;
                      },*/
                    ),
                    CustomFormField(
                      controller: buyerNameController,
                      mandatorySymbol: "*",
                      title: 'Name of buyer',
                      hintText: 'Enter buyer name',
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid name"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: buyerAddressController,
                      mandatorySymbol: "*",
                      title: 'Buyer address',
                      hintText: 'Enter buyer address',
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z.\d]+$')
                                    .hasMatch(value))
                            ? "Please enter valid address"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: buyerGstNumberController,
                      mandatorySymbol: "",
                      title: "Buyer GST number",
                      hintText: "Enter buyer GST number",
                      maxLength: 15,
                      counterText: "",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      /*validator: (String? value) {
                        return (value!.isEmpty ||
                                    !RegExp(r'[^-\s][A-Z\d]+$')
                                        .hasMatch(value)) ||
                                value.length != 15
                            ? "Please enter valid GST number"
                            : null;
                      },*/
                    ),
                    CustomFormField(
                      controller: vehicleNumberController,
                      mandatorySymbol: "",
                      title: "Vehicle number",
                      hintText: "Enter vehicle number",
                      maxLength: 10,
                      counterText: "",
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      /*validator: (String? value) {
                        return (value!.isEmpty ||
                                    !RegExp(r'[^-\s][A-Z\d]+$')
                                        .hasMatch(value)) ||
                                value.length != 10
                            ? "Please enter valid GST number"
                            : null;
                      },*/
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
