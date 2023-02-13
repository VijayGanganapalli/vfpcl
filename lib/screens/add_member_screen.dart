import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/constants/country_data.dart';
import 'package:vfpcl/widgets/custom_form_field.dart';

import '../widgets/custom_alert_dialog.dart';
import '../widgets/custom_dropdown.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _addMemberFormKey = GlobalKey<FormState>();
  int genderIconSelected = 0;
  int memberId = 0;
  File? memberImageFile;
  String? memberImgUrl;
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
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  String? startDate;
  String? endDate;

  final fullNameController = TextEditingController();
  final surnameController = TextEditingController();
  final fatherOrHusbandNameController = TextEditingController();
  final fatherOrHusbandSurnameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  final panController = TextEditingController();
  final emailController = TextEditingController();
  final landHoldingController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final mandalController = TextEditingController();
  final villageController = TextEditingController();
  final habitationController = TextEditingController();
  final nomineeController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final shareHoldingController = TextEditingController();
  final directorPeriodController = TextEditingController();

  final CollectionReference _membersRef = FirebaseFirestore.instance
      .collection("fpcs")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("members");

  Future getMembersCount() async {
    QuerySnapshot memSnap = await _membersRef.get();
    setState(() {
      memberId = memSnap.size;
    });
  }

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
        memberImageFile = File(croppedImage.path);
      });
    } else {
      memberImageFile = null;
    }
  }

  Widget customRadio(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          genderIconSelected = index;
        });
      },
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: backgroundColor,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: genderIconSelected == index ? defaultColor : greyColor,
        ),
      ),
    );
  }

  Future<String?> addMember() async {
    final document = _membersRef.doc();
    final uid = document.id;
    QuerySnapshot memberSnapshot = await _membersRef.get();
    var vAadhar = memberSnapshot.docs.map((e) => e['aadharNumber']);
    var vMobile = memberSnapshot.docs.map((e) => e['mobileNumber']);
    var vPan = memberSnapshot.docs.map((e) => e['pan']);
    if (memberImageFile == null) {
      if (!mounted) return null;
      alertDialogBuilder(context, "Please upload member photo");
    } else if (vAadhar
        .any((element) => element == int.parse(aadharController.text.trim()))) {
      if (!mounted) return null;
      alertDialogBuilder(context, "This aadhar number already registered");
    } else if (vMobile
        .any((element) => element == int.parse(mobileController.text.trim()))) {
      if (!mounted) return null;
      alertDialogBuilder(context, "This mobile number already registered");
    } else if (vPan
        .any((element) => element == panController.text.trim().toString())) {
      if (!mounted) return null;
      alertDialogBuilder(context, "This pan number already registered");
    } else {
      setState(() {
        memberId = memberSnapshot.size;
      });
      final memberImgRef = FirebaseStorage.instance
          .ref()
          .child("memberImages")
          .child("$uid.jpg");
      await memberImgRef.putFile(memberImageFile!);
      memberImgUrl = await memberImgRef.getDownloadURL();
      await _membersRef.doc(uid).set({
        'memberId': ++memberId,
        'memberImgUrl': memberImgUrl,
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
        'landHolding': double.parse(landHoldingController.text.trim()),
        'country': selectedCountry!.trim(),
        'state': selectedState!.trim(),
        'district': selectedDistrict!.trim(),
        'mandal': selectedMandal!.trim(),
        'revenueVillage': selectedRevenueVillage!.trim(),
        'habitation': selectedHabitation!.trim(),
        'nomineeFullName': nomineeController.text.trim(),
        'relationWithNominee': relationWithNominee!.trim(),
        'joiningDate':
            DateFormat("dd-MM-yyyy").parse(dateOfJoiningController.text.trim()),
        'shareHolding': int.parse(shareHoldingController.text.trim()),
        'designation': selectedDesignation!.trim(),
        'directorPeriod': directorPeriodController.text.trim(),
      }).whenComplete(() async {
        await alertDialogBuilder(context, "Member added successfully");
        if (!mounted) return;
        Navigator.pop(context);
      });
      return null;
    }
    return null;
  }

  void _submitForm() async {
    String? loginAccountFeedback = await addMember();

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
    landHoldingController.dispose();
    stateController.dispose();
    districtController.dispose();
    districtController.dispose();
    mandalController.dispose();
    villageController.dispose();
    habitationController.dispose();
    nomineeController.dispose();
    dateOfJoiningController.dispose();
    shareHoldingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                if (_addMemberFormKey.currentState!.validate()) {
                  _submitForm();
                }
              },
              icon: const Icon(Icons.cloud_upload_outlined),
            ),
          ),
        ],
      ),
      body: Form(
        key: _addMemberFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              isUploading == true
                  ? const CircularProgressIndicator()
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Center(
                  child: Container(
                    height: 140,
                    width: 140,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: memberImageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(memberImageFile!),
                          )
                        : InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Please choose an option",
                                      style:
                                          Theme.of(context).textTheme.headline2,
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
                                                padding: EdgeInsets.all(8.0),
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
                                                padding: EdgeInsets.all(8.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: greyColor,
                              fontSize: 15,
                            ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: gender == null,
                    child: Row(
                      children: const [
                        SizedBox(width: 16),
                        Text(
                          "Please select gender",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12, color: errorColor),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
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
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: greyColor,
                              fontSize: 15,
                            ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: maritalStatus == null,
                    child: Row(
                      children: const [
                        SizedBox(width: 16),
                        Text(
                          "Please select marital status",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12, color: errorColor),
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
                              !RegExp(r'[^-\s][A-Z\d]+$').hasMatch(value)) ||
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
              CustomFormField(
                controller: landHoldingController,
                mandatorySymbol: "*",
                title: "Land holding",
                hintText: "Enter your land holding in acres",
                obscureText: false,
                maxLength: 4,
                counterText: "",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.none,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return (value!.isEmpty ||
                              !RegExp(r'^\d.+$').hasMatch(value)) ||
                          value.length != 4
                      ? "Please enter valid number"
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
                  selectedMandal == null ? null : selectedHabitation = null;
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
                controller: nomineeController,
                mandatorySymbol: "*",
                title: "Nominee full name",
                hintText: "Enter your nominee full name with surname",
                obscureText: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return (value!.isEmpty ||
                          !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                      ? "Please enter nominee full name"
                      : null;
                },
              ),
              CustomDropdown(
                title: "Relation with nominee",
                mandatorySymbol: "*",
                hintText: "Select relation with nominee",
                value: relationWithNominee,
                items: [
                  'Father',
                  'Mother',
                  'Husband',
                  'Wife',
                  'Son',
                  'Daughter'
                ].map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (String? value) {
                  relationWithNominee = null;
                  setState(() {
                    relationWithNominee = value;
                  });
                },
                validator: (String? value) {
                  return relationWithNominee == null
                      ? "Please select relation with nominee"
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
              CustomFormField(
                controller: shareHoldingController,
                mandatorySymbol: "*",
                title: "No of shares holding",
                hintText: "No of shares holding",
                obscureText: false,
                maxLength: 4,
                counterText: "",
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.none,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return (value!.isEmpty || !RegExp(r'^\d+$').hasMatch(value))
                      ? "Please enter number of shares holding"
                      : null;
                },
              ),
              CustomDropdown(
                title: "Designation",
                mandatorySymbol: "*",
                hintText: "Select your designation",
                value: selectedDesignation,
                items: ['Member', 'Director']
                    .map<DropdownMenuItem<String>>((String value) {
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
              Visibility(
                visible: selectedDesignation == "Director",
                child: CustomFormField(
                  readOnly: true,
                  autofocus: false,
                  controller: directorPeriodController,
                  mandatorySymbol: "*",
                  title: "Director period",
                  hintText: directorPeriodController.text.isEmpty
                      ? "Select director period"
                      : directorPeriodController.text,
                  suffixIcon: const Icon(Icons.calendar_month),
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    DateTimeRange? dateTimeRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: selectedDates,
                      firstDate: DateTime(2022, 10),
                      lastDate: DateTime(2080),
                    );

                    if (dateTimeRange != null &&
                        dateTimeRange != selectedDates) {
                      var sDate =
                          DateFormat("dd-MM-yyyy").format(selectedDates.start);
                      var eDate =
                          DateFormat("dd-MM-yyyy").format(selectedDates.end);
                      setState(() {
                        selectedDates = dateTimeRange;
                        sDate = DateFormat("dd-MM-yyyy")
                            .format(dateTimeRange.start);
                        eDate =
                            DateFormat("dd-MM-yyyy").format(dateTimeRange.end);
                        startDate = sDate;
                        endDate = eDate;
                        directorPeriodController.text = "$startDate - $endDate";
                      });
                    }
                  },
                  validator: (String? value) {
                    return (value!.isEmpty ||
                            !RegExp(r'[^-\s][\d-]+$').hasMatch(value))
                        ? "Please select valid date range"
                        : null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
