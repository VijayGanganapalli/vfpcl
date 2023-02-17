import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/constants/device.dart';
import 'package:vfpcl/widgets/custom_button.dart';
import 'package:vfpcl/widgets/custom_form_field.dart';

import '../../widgets/custom_alert_dialog.dart';
import '../forgot_password_screen.dart';
import '../sign_up_screen/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final signInFormKey = GlobalKey<FormState>();
  final device = Device();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginFormLoading = false;
  bool passwordVisibility = true;

  Future<String?> signInAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
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
      } else if (emailController.text.isEmpty) {
        return 'Email field cannot be empty';
      } else if (passwordController.text.isEmpty) {
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            //reverse: true,
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: signInFormKey,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: Image.asset(
                        "assets/images/company_no_bg_logo.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(
                      width: device.width(context),
                      child: CustomFormField(
                        controller: emailController,
                        mandatorySymbol: "",
                        keyboardType: TextInputType.emailAddress,
                        title: "Email",
                        hintText: "Enter email address",
                        obscureText: false,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          return (value!.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value))
                              ? "Please enter a valid email address"
                              : null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: device.width(context),
                      child: CustomFormField(
                        controller: passwordController,
                        mandatorySymbol: "",
                        keyboardType: TextInputType.text,
                        title: "Password",
                        hintText: "Enter password",
                        obscureText: true,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          return (value!.isEmpty ||
                                  !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                      .hasMatch(value))
                              ? "Contains at least one letter, number, special char"
                              : null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: device.width(context),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                            text: "Forgot password? ",
                            style: Theme.of(context).textTheme.bodyText1,
                            children: [
                              TextSpan(
                                text: "Reset here!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: primaryColor,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: device.width(context),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: CustomButton(
                          isLoading: loginFormLoading,
                          buttonText: "Sign In",
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
                          buttonText: "Sign Up",
                          outlineButton: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
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
      ),
    );
  }
}
