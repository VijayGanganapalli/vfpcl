import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

import '../add_member_screen.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor.withOpacity(0.08),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('fpcs')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('members')
              .orderBy("memberId", descending: true)
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
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('There is no members enrolled'),
              );
            }
            if (snapshot.hasData) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  return ListTile(
                    isThreeLine: true,
                    tileColor: backgroundColor,
                    contentPadding: const EdgeInsets.all(6),
                    leading: CircleAvatar(
                      backgroundColor: greyColor.withOpacity(0.2),
                      radius: 30.0,
                      child: document['memberImgUrl'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(document['memberImgUrl'],
                                  width: 60, height: 60, fit: BoxFit.fill),
                            )
                          : const Icon(Icons.person,
                              size: 45, color: greyColor),
                    ),
                    title: Text(document['fullName']),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${document['maritalTitle']} ${document['fatherOrHusbandName']}"),
                        const SizedBox(height: 2),
                        Text(
                            "${document['habitation']}, ${document['revenueVillage']}"),
                        const SizedBox(height: 2),
                        Text(
                            "${document['mandal']}. Holdings: ${document['shareHolding']}"),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Member ID",
                          softWrap: true,
                          style: TextStyle(color: greyColor),
                        ),
                        Text(document['memberId'].toString()),
                      ],
                    ),
                  );
                }).toList(),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMemberScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
