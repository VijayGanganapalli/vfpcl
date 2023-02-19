import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/device.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signUpFormKey = GlobalKey<FormState>();
  final device = Device();
  DateTime selectedDoi = DateTime.now();
  final companyNameController = TextEditingController();
  final incorporatedDateController = TextEditingController();
  final cinController = TextEditingController();
  final panController = TextEditingController();
  final tanController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final companyAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool signUpFormLoading = false;
  bool passwordVisibility = true;

  Future<String?> signUpAccount() async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      return 'Password and confirm password should be same';
    }
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      confirmPasswordController.text.trim();
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: confirmPasswordController.text.trim(),
      );
      var uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('fpcs').doc(uid).set({
        'uid': uid,
        'companyName': companyNameController.text.trim(),
        'companyIncorporatedDate': DateFormat("dd-MM-yyyy")
            .parse(incorporatedDateController.text.trim()),
        'companyCIN': cinController.text.trim().toUpperCase(),
        'companyPAN': panController.text.trim().toUpperCase(),
        'companyTAN': tanController.text.trim().toUpperCase(),
        'emailAddress': emailController.text.trim(),
        'contactNumber': int.parse(contactController.text.trim()),
        'companyAddress': companyAddressController.text.trim(),
        'createdAt': Timestamp.now(),
      }).whenComplete(() async {
        await alertDialogBuilder(context, "Account created successfully");
        if (!mounted) return;
        Navigator.pop(context);
      }).catchError((error) async {
        await alertDialogBuilder(
            context, "You are not able to create account due to $error");
        if (!mounted) return;
        Navigator.pop(context);
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (companyNameController.text.isEmpty ||
          incorporatedDateController.text.isEmpty ||
          cinController.text.isEmpty ||
          panController.text.isEmpty ||
          tanController.text.isEmpty ||
          emailController.text.isEmpty ||
          contactController.text.isEmpty ||
          companyAddressController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        return 'Please fill all mandatory fields';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void submitForm() async {
    setState(() {
      signUpFormLoading = true;
    });
    String? loginAccountFeedback = await signUpAccount();
    if (loginAccountFeedback != null) {
      if (!mounted) return;
      alertDialogBuilder(context, loginAccountFeedback);
      setState(() {
        signUpFormLoading = false;
      });
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    incorporatedDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: signUpFormKey,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Image.asset(
                    "assets/images/company_no_bg_logo.png",
                    width: 100,
                    height: 100,
                  ),
                ),
                Expanded(
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        width: device.width(context),
                        child: CustomFormField(
                          controller: companyNameController,
                          mandatorySymbol: "*",
                          keyboardType: TextInputType.text,
                          title: "Producer company name",
                          hintText: "Enter producer company full name",
                          obscureText: false,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'[^-\s][a-z A-Z]+$')
                                        .hasMatch(value))
                                ? "Please enter valid company name"
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: device.width(context),
                        child: CustomFormField(
                          readOnly: true,
                          autofocus: false,
                          controller: incorporatedDateController,
                          mandatorySymbol: "*",
                          title: "Company incorporated date",
                          hintText: incorporatedDateController.text.isEmpty
                              ? "Select date of company incorporated"
                              : incorporatedDateController.text,
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
                              initialDate: selectedDoi,
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null &&
                                pickedDate != selectedDoi) {
                              setState(() {
                                selectedDoi = pickedDate;
                                incorporatedDateController.text =
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
                      ),
                      SizedBox(
                        width: device.width(context),
                        child: CustomFormField(
                          controller: cinController,
                          mandatorySymbol: "*",
                          keyboardType: TextInputType.text,
                          title: "Company CIN",
                          hintText: "Enter company CIN",
                          obscureText: false,
                          counterText: "",
                          maxLength: 21,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                        !RegExp(r'[^-\s][A-Z\d]+$')
                                            .hasMatch(value)) ||
                                    value.length != 21
                                ? "Please enter valid CIN"
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: device.width(context),
                        child: CustomFormField(
                          controller: panController,
                          mandatorySymbol: "*",
                          title: "Company PAN",
                          hintText: "Enter company PAN",
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
                                ? "Please enter valid PAN"
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: device.width(context),
                        child: CustomFormField(
                          controller: tanController,
                          mandatorySymbol: "*",
                          title: "Company TAN",
                          hintText: "Enter company TAN",
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
                                ? "Please enter valid TAN"
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: device.width(context),
                        child: CustomFormField(
                          controller: emailController,
                          mandatorySymbol: "*",
                          title: "Company email",
                          hintText: "Enter company email address",
                          obscureText: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !value.endsWith("@gmail.com") ||
                                    !RegExp(r'[^-\s][a-zA-Z\d]*$')
                                        .hasMatch(value))
                                ? "Please enter valid email"
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        child: CustomFormField(
                          controller: contactController,
                          mandatorySymbol: "*",
                          title: "Company contact number",
                          hintText: "Enter company contact number",
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
                      ),
                      SizedBox(
                        child: CustomFormField(
                          title: "Company address",
                          hintText: "Enter company address",
                          mandatorySymbol: " *",
                          obscureText: false,
                          controller: companyAddressController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'[^-\s][a-zA-Z\d#,.-/]+$')
                                        .hasMatch(value))
                                ? "Please enter valid address"
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        child: CustomFormField(
                          obscureText: true,
                          controller: passwordController,
                          title: "Password",
                          mandatorySymbol: " *",
                          hintText: "Set password",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                        .hasMatch(value))
                                ? "Contains at least one letter, number, special char"
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        child: CustomFormField(
                          obscureText: passwordVisibility,
                          controller: confirmPasswordController,
                          title: "Confirm password",
                          mandatorySymbol: " *",
                          hintText: "Enter confirm password",
                          suffixIcon: IconButton(
                              color: primaryColor,
                              icon: passwordVisibility
                                  ? const Icon(Icons.visibility_outlined)
                                  : const Icon(Icons.visibility_off_outlined),
                              onPressed: () {
                                setState(() {
                                  passwordVisibility = !passwordVisibility;
                                });
                              }),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                        .hasMatch(value))
                                ? "Contains at least one letter, number, special char"
                                : null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: device.width(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: CustomButton(
                      isLoading: signUpFormLoading,
                      buttonText: "Sign Up",
                      outlineButton: false,
                      onPressed: () {
                        try {
                          if (signUpFormKey.currentState!.validate()) {
                            submitForm();
                          } else {
                            submitForm();
                          }
                        } finally {
                          setState(() {
                            signUpFormLoading = true;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: device.width(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CustomButton(
                      isLoading: signUpFormLoading = false,
                      buttonText: "Back",
                      outlineButton: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
