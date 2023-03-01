import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vfpcl/constants/colors.dart';

import '../../../constants/country_data.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_form_field.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _addEmployeeFormKey = GlobalKey<FormState>();
  int employeeId = 0;
  File? employeeImageFile;
  String? employeeImgUrl;
  bool isUploading = false;
  String? gender;
  String? maritalStatus;
  String? selectedCountry;
  String? selectedState;
  String? selectedDistrict;
  String? selectedMandal;
  String? selectedRevenueVillage;
  String? selectedHabitation;
  String? relationWithNominee;
  String? selectedDesignation;
  DateTime selectedDob = DateTime(2004);
  DateTime selectedDoj = DateTime.now();
  bool isGenderValidate = false;
  bool isMaritalStatusValidate = false;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController fatherOrHusbandNameController =
      TextEditingController();
  final TextEditingController fatherOrHusbandSurnameController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController mandalController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController habitationController = TextEditingController();
  final TextEditingController dateOfJoiningController = TextEditingController();

  final CollectionReference _employeesRef = FirebaseFirestore.instance
      .collection("fpcs")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("employees");

  String maritalTitle() {
    if (fatherOrHusbandNameHintText() == "Father name" && gender == "Female") {
      return "D/o";
    } else if (fatherOrHusbandNameHintText() == "Husband name") {
      return "W/o";
    }
    return "S/o";
  }

  String fatherOrHusbandNameHintText() {
    if (gender == "Female" && maritalStatus == "Married") {
      return "Husband name";
    }
    return "Father name";
  }

  String fatherOrHusbandSurnameHintText() {
    if (gender == "Female" && maritalStatus == "Married") {
      return "Husband surname";
    }
    return "Father surname";
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
        employeeImageFile = File(croppedImage.path);
      });
    } else {
      employeeImageFile = null;
    }
  }

  Future<String?> addEmployee() async {
    final document = _employeesRef.doc();
    final uid = document.id;
    final user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot employeeSnapshot = await _employeesRef.get();
    var vAadhar = employeeSnapshot.docs.map((e) => e['aadharNumber']);
    var vMobile = employeeSnapshot.docs.map((e) => e['mobileNumber']);
    var vPan = employeeSnapshot.docs.map((e) => e['pan']);
    if (employeeImageFile == null) {
      if (!mounted) return null;
      alertDialogBuilder(context, "Please upload employee photo");
    } else if (vMobile
        .any((element) => element == int.parse(mobileController.text.trim()))) {
      if (!mounted) return null;
      alertDialogBuilder(context, "This mobile number already registered");
    } else if (vAadhar
        .any((element) => element == int.parse(aadharController.text.trim()))) {
      if (!mounted) return null;
      alertDialogBuilder(context, "This aadhar number already registered");
    } else if (vPan
        .any((element) => element == panController.text.trim().toString())) {
      if (!mounted) return null;
      alertDialogBuilder(context, "This pan number already registered");
    } else {
      setState(() {
        employeeId = employeeSnapshot.size;
      });
      final employeeImgRef = FirebaseStorage.instance
          .ref()
          .child("employeeImages")
          .child("${user.email}")
          .child("$uid.jpg");
      await employeeImgRef.putFile(employeeImageFile!);
      employeeImgUrl = await employeeImgRef.getDownloadURL();
      await _employeesRef.doc(uid).set({
        'memberId': 'VFPCL${++employeeId}',
        'memberImgUrl': employeeImgUrl,
        'fullName':
            '${fullNameController.text.trim()} ${surnameController.text.trim()}',
        'gender': gender,
        'maritalStatus': maritalStatus,
        'maritalTitle': maritalTitle(),
        'fatherOrHusbandName':
            '${fatherOrHusbandNameController.text.trim()} ${fatherOrHusbandSurnameController.text.trim()}',
        'dateOfBirth':
            DateFormat("dd-MM-yyyy").parse(dobController.text.trim()),
        'mobileNumber': int.parse(mobileController.text.trim()),
        'aadharNumber': int.parse(aadharController.text.trim()),
        'pan': panController.text.trim(),
        'email': emailController.text.trim(),
        'country': selectedCountry!.trim(),
        'state': selectedState!.trim(),
        'district': selectedDistrict!.trim(),
        'mandal': selectedMandal!.trim(),
        'revenueVillage': selectedRevenueVillage!.trim(),
        'habitation': selectedHabitation!.trim(),
        'joiningDate':
            DateFormat("dd-MM-yyyy").parse(dateOfJoiningController.text.trim()),
        'designation': selectedDesignation!.trim(),
      }).whenComplete(() async {
        setState(() {
          isUploading = false;
        });
        await alertDialogBuilder(context, "Employee added successfully");
        if (!mounted) return;
        Navigator.pop(context);
      }).catchError((error) async {
        setState(() {
          isUploading = false;
        });
        await alertDialogBuilder(
            context, "You are not able to add employee due to $error");
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
    String? loginAccountFeedback = await addEmployee();
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
    fullNameController.dispose();
    surnameController.dispose();
    fatherOrHusbandNameController.dispose();
    fatherOrHusbandSurnameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    aadharController.dispose();
    panController.dispose();
    emailController.dispose();
    stateController.dispose();
    districtController.dispose();
    districtController.dispose();
    mandalController.dispose();
    villageController.dispose();
    habitationController.dispose();
    dateOfJoiningController.dispose();
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
              "Add Employee",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      gender == null
                          ? isGenderValidate = true
                          : isGenderValidate = false;
                      maritalStatus == null
                          ? isMaritalStatusValidate = true
                          : isMaritalStatusValidate = false;
                    });
                    if (_addEmployeeFormKey.currentState!.validate()) {
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
              key: _addEmployeeFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: Container(
                          height: 140,
                          width: 140,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: greyColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: employeeImageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(employeeImageFile!),
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
                                  child: const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 60,
                                    color: greyColor,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    CustomFormField(
                      controller: fullNameController,
                      mandatorySymbol: "*",
                      title: "Full name",
                      hintText: "Enter your full name",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid text"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: surnameController,
                      mandatorySymbol: "*",
                      title: "Surname",
                      hintText: "Enter your surname",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid text"
                            : null;
                      },
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "*",
                                  style: TextStyle(color: errorColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              activeColor: primaryColor,
                              value: "Male",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                            Text(
                              "Male",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                            ),
                            Radio(
                              activeColor: primaryColor,
                              value: "Female",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                            Text(
                              "Female",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                            ),
                            Radio(
                              activeColor: primaryColor,
                              value: "Others",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                            Text(
                              "Others",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: isGenderValidate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              SizedBox(width: 12),
                              Text(
                                "Please select gender",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: errorColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Marital status",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "*",
                                  style: TextStyle(color: errorColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              activeColor: primaryColor,
                              value: "Married",
                              groupValue: maritalStatus,
                              onChanged: (value) {
                                setState(() {
                                  maritalStatus = value.toString();
                                });
                              },
                            ),
                            Text(
                              "Married",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                            ),
                            Radio(
                              activeColor: primaryColor,
                              value: "Unmarried",
                              groupValue: maritalStatus,
                              onChanged: (value) {
                                setState(() {
                                  maritalStatus = value.toString();
                                });
                              },
                            ),
                            Text(
                              "Unmarried",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: greyColor,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: isMaritalStatusValidate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              SizedBox(width: 12),
                              Text(
                                "Please select marital status",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: errorColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    CustomFormField(
                      controller: fatherOrHusbandNameController,
                      mandatorySymbol: "*",
                      title: fatherOrHusbandNameHintText(),
                      hintText: fatherOrHusbandNameHintText(),
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid text"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: fatherOrHusbandSurnameController,
                      mandatorySymbol: "*",
                      title: fatherOrHusbandSurnameHintText(),
                      hintText: fatherOrHusbandSurnameHintText(),
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                            ? "Please enter valid text"
                            : null;
                      },
                    ),
                    CustomFormField(
                      readOnly: true,
                      autofocus: false,
                      controller: dobController,
                      mandatorySymbol: "*",
                      title: "Date of birth",
                      hintText: dobController.text.isEmpty
                          ? "Select your date of birth"
                          : dobController.text,
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
                          initialDate: selectedDob,
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2004),
                        );
                        if (pickedDate != null && pickedDate != selectedDob) {
                          setState(() {
                            selectedDob = pickedDate;
                            dobController.text =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][\d-]+$').hasMatch(value))
                            ? "Please enter valid text"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: mobileController,
                      mandatorySymbol: "*",
                      title: "Mobile",
                      hintText: "Enter your mobile number",
                      obscureText: false,
                      maxLength: 10,
                      counterText: "",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                    !RegExp(r'^\d+$').hasMatch(value)) ||
                                value.length != 10
                            ? "Please enter 10 digit mobile number"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: aadharController,
                      mandatorySymbol: "*",
                      title: "Aadhar",
                      maxLength: 12,
                      counterText: "",
                      hintText: "Enter your aadhar number",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                    !RegExp(r'^\d+$').hasMatch(value)) ||
                                value.length != 12
                            ? "Please enter 12 digit aadhar number"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: panController,
                      mandatorySymbol: "*",
                      title: "Pan",
                      hintText: "Enter your pan number",
                      maxLength: 10,
                      counterText: "",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                    !RegExp(r'[^-\s][A-Z\d]+$')
                                        .hasMatch(value)) ||
                                value.length != 10
                            ? "Please enter valid pan number"
                            : null;
                      },
                    ),
                    CustomFormField(
                      controller: emailController,
                      mandatorySymbol: "*",
                      title: "Email",
                      hintText: "Enter your email address",
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !value.endsWith("@gmail.com") ||
                                !RegExp(r'[^-\s][a-zA-Z\d]*$').hasMatch(value))
                            ? "Please enter valid email"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "Country",
                      mandatorySymbol: "*",
                      hintText: "Select your country",
                      value: selectedCountry,
                      items: CountryData().states.keys.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        selectedState = null;
                        selectedDistrict = null;
                        selectedMandal = null;
                        selectedRevenueVillage = null;
                        selectedHabitation = null;
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                      validator: (String? value) {
                        return selectedCountry == null
                            ? "Please select your country"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "State",
                      mandatorySymbol: "*",
                      hintText: "Select your state",
                      value: selectedState,
                      items: CountryData()
                          .states[selectedCountry]
                          ?.map<DropdownMenuItem<String>>((dependentOption) {
                        return DropdownMenuItem<String>(
                          value: dependentOption,
                          child: Text(dependentOption),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        selectedDistrict = null;
                        selectedMandal = null;
                        selectedRevenueVillage = null;
                        selectedHabitation = null;
                        setState(() {
                          selectedState = value;
                        });
                      },
                      validator: (String? value) {
                        return selectedState == null
                            ? "Please select your state"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "District",
                      mandatorySymbol: "*",
                      hintText: "Select your district",
                      value: selectedDistrict,
                      items: CountryData()
                          .districts[selectedState]
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        selectedMandal = null;
                        selectedRevenueVillage = null;
                        selectedHabitation = null;
                        setState(() {
                          selectedDistrict = value;
                        });
                      },
                      validator: (String? value) {
                        return selectedDistrict == null
                            ? "Please select your district"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "Mandal",
                      mandatorySymbol: "*",
                      hintText: "Select your mandal",
                      value: selectedMandal,
                      items: CountryData()
                          .mandals[selectedDistrict]
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        selectedRevenueVillage = null;
                        selectedHabitation = null;
                        setState(() {
                          selectedMandal = value;
                        });
                      },
                      validator: (String? value) {
                        return selectedMandal == null
                            ? "Please select your mandal"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "Revenue village",
                      mandatorySymbol: "*",
                      hintText: "Select your revenue village",
                      value: selectedRevenueVillage,
                      items: CountryData()
                          .revenueVillages[selectedMandal]
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        selectedMandal == null
                            ? null
                            : selectedHabitation = null;
                        setState(() {
                          selectedRevenueVillage = value;
                        });
                      },
                      validator: (String? value) {
                        return selectedRevenueVillage == null
                            ? "Please select your revenue village"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "Habitation",
                      mandatorySymbol: "*",
                      hintText: "Select your habitation",
                      value: selectedHabitation,
                      items: CountryData()
                          .habitations[selectedRevenueVillage]
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        selectedHabitation = null;
                        setState(() {
                          selectedHabitation = value;
                        });
                      },
                      validator: (String? value) {
                        return selectedHabitation == null
                            ? "Please select your habitation"
                            : null;
                      },
                    ),
                    CustomFormField(
                      readOnly: true,
                      autofocus: false,
                      controller: dateOfJoiningController,
                      mandatorySymbol: "*",
                      title: "Date of joining",
                      hintText: dateOfJoiningController.text.isEmpty
                          ? "Select your date of joining"
                          : dateOfJoiningController.text,
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
                          initialDate: selectedDoj,
                          firstDate: DateTime(2022),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null && pickedDate != selectedDoj) {
                          setState(() {
                            selectedDoj = pickedDate;
                            dateOfJoiningController.text =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'[^-\s][\d-]+$').hasMatch(value))
                            ? "Please enter valid date"
                            : null;
                      },
                    ),
                    CustomDropdown(
                      title: "Designation",
                      mandatorySymbol: "*",
                      hintText: "Select your designation",
                      value: selectedDesignation,
                      items: [
                        'Chief Executive Officer',
                        'Manager',
                        'Community Organizer'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        selectedDesignation = null;
                        setState(() {
                          selectedDesignation = value;
                        });
                      },
                      validator: (String? value) {
                        return selectedDesignation == null
                            ? "Please select your designation"
                            : null;
                      },
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
