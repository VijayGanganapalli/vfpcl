import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/device.dart';

import '../constants/colors.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final device = Device();
  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<String?> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (_emailController.text.isEmpty) {
        return 'Please enter your email address';
      } else if (e.code == 'invalid-email') {
        return 'Email address is invalid';
      } else if (e.code == 'user-not-found') {
        return 'No user found with this email';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    String? loginAccountFeedback = await _resetPassword();
    if (loginAccountFeedback != null) {
      if (!mounted) return;
      alertDialogBuilder(context, loginAccountFeedback);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reset password"),
      ),
      body: Center(
        child: SizedBox(
          width: device.width(context),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter your email and we will send you a password reset link",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  CustomFormField(
                    obscureText: false,
                    controller: _emailController,
                    title: "",
                    mandatorySymbol: "",
                    hintText: "Email",
                    //fillColor: accentColor,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      return (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value))
                          ? "Please enter valid email "
                          : null;
                    },
                  ),
                  // Reset password button
                  Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: CustomButton(
                      buttonText: "Reset password",
                      outlineButton: false,
                      onPressed: _submit,
                      isLoading: isLoading,
                    ),
                  ),
                  SizedBox(
                    width: device.width(context),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: CustomButton(
                        isLoading: isLoading = false,
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
      ),
    );
  }
}
