import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/device.dart';

import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  final String appBarTitle;
  const ProfileScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final device = Device();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Signed in as: ${user.email}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              SizedBox(
                width: device.width(context),
                child: CustomButton(
                  buttonText: "Sign Out",
                  outlineButton: false,
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
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
