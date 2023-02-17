import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final fpcNameController = TextEditingController();
  final incorporatedDateController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final cinController = TextEditingController();
  final panController = TextEditingController();
  final tanController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final companyAddressController = TextEditingController();

  bool loginFormLoading = false;
  bool passwordVisibility = true;

  Future<String?> signInAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: fpcNameController.text.trim(),
        password: incorporatedDateController.text.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'Email address is invalid';
      } else if (e.code == 'user-not-found') {
        return 'There is no account with this email';
      } else if (e.code == 'user-disabled') {
        return 'User corresponding to the given email has been disabled';
      } else if (e.code == 'wrong-password') {
        return 'You entered wrong password';
      } else if (fpcNameController.text.isEmpty) {
        return 'Email field cannot be empty';
      } else if (incorporatedDateController.text.isEmpty) {
        return 'Password field cannot be empty';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void submitForm() async {
    setState(() {
      loginFormLoading = true;
    });
    String? loginAccountFeedback = await signInAccount();
    if (loginAccountFeedback != null) {
      if (!mounted) return;
      alertDialogBuilder(context, loginAccountFeedback);

      setState(() {
        loginFormLoading = false;
      });
    }
  }

  @override
  void dispose() {
    fpcNameController.dispose();
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
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        width: device.width(context),
                        child: CustomFormField(
                          controller: fpcNameController,
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
                                ? "Please enter valid name"
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
                                ? "Please enter valid pan number"
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
                                ? "Please enter valid pan number"
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
                    ],
                  ),
                ),
                SizedBox(
                  width: device.width(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: CustomButton(
                      isLoading: loginFormLoading,
                      buttonText: "Sign Up",
                      outlineButton: false,
                      onPressed: () {
                        submitForm();
                        setState(() {
                          loginFormLoading = true;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: device.width(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CustomButton(
                      isLoading: loginFormLoading = false,
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
