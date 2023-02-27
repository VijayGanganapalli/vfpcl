import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/constants/device.dart';
import 'package:vfpcl/widgets/custom_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  final String appBarTitle;
  const ProfileScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final device = Device();
  File? memberImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('fpcs')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            );
          }
          if (snapshot.hasData) {
            var companyName = snapshot.data!.get('companyName');
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 32),
                Image.asset(
                  "assets/images/company_no_bg_logo.png",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 8),
                Text(
                  companyName.toString().split(" ")[0],
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Farmer Producer Company Limited",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    //wordSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "CIN: ${snapshot.data!.get('companyCIN')}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: greyColor),
                ),
                const SizedBox(height: 8),
                Text(
                  "Email: ${snapshot.data!.get('emailAddress')}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: greyColor),
                ),
                Text(
                  "Address: ${snapshot.data!.get('companyAddress')}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: greyColor,
                    wordSpacing: 2,
                    height: 1.8,
                  ),
                  softWrap: true,
                ),
                Divider(
                  thickness: 3,
                  height: 60,
                  indent: MediaQuery.of(context).size.width / 2.8,
                  endIndent: MediaQuery.of(context).size.width / 2.8,
                ),
                const CustomListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: "Settings",
                ),
                const SizedBox(height: 16),
                const CustomListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: "Privacy",
                ),
                const SizedBox(height: 16),
                const CustomListTile(
                  leading: Icon(Icons.info_outline),
                  title: "About us",
                ),
                const SizedBox(height: 16),
                const CustomListTile(
                  leading: Icon(Icons.help_outline),
                  title: "Help & Support",
                ),
                const SizedBox(height: 16),
                CustomListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: "Sign out",
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
