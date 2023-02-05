import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/constants/country_data.dart';
import 'package:vfpcl/widgets/custom_form_field.dart';

import '../widgets/custom_dropdown.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _addMemberFormKey = GlobalKey<FormState>();
  int genderIconSelected = 0;
  Uint8List? memberImageFile;
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
  DateTime selectedDob = DateTime(2004);
  TextEditingController fullNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController fatherOrHusbandNameController = TextEditingController();
  TextEditingController fatherOrHusbandSurnameController =
      TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController landHoldingController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController mandalController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController habitationController = TextEditingController();
  TextEditingController nomineeController = TextEditingController();
  TextEditingController shareHoldingController = TextEditingController();

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

  // upload form screen
  Widget uploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member"),
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
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: memberImageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(memberImageFile!))
                        : const Icon(Icons.image, size: 120, color: greyColor),
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
                    firstDate: DateTime(1962),
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
                title: "PAN",
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
                  selectedHabitation = null;
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
                      ? "Please enter valid text"
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
                  setState(() {
                    relationWithNominee = value;
                  });
                },
                validator: (String? value) {
                  return value!.isEmpty
                      ? "Please select relation with nominee"
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
            ],
          ),
        ),
      ),
    );
  }

  // default screen for upload new item
  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member"),
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
            TextButton(
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
                                  memberImageFile =
                                      await pickedImage.readAsBytes();
                                  // remove background from image
                                  // make image transparent
                                  setState(() {
                                    memberImageFile;
                                  });
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                }
                              } catch (error) {
                                setState(() {
                                  memberImageFile = null;
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
                                  memberImageFile =
                                      await pickedImage.readAsBytes();
                                  // remove background from image
                                  // make image transparent
                                  setState(() {
                                    memberImageFile;
                                  });
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                }
                              } catch (error) {
                                setState(() {
                                  memberImageFile = null;
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
                "Add member photo",
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
    return memberImageFile == null ? defaultScreen() : uploadFormScreen();
  }
}
