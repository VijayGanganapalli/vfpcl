import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'add_employee_screen.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor.withOpacity(0.08),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('fpcs')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('employees')
              .orderBy("joiningDate", descending: false)
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
              return Center(
                child: Text(
                  'There is no employee appointed',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  final date = DateTime.parse(
                      document['joiningDate'].toDate().toString());
                  final empId =
                      "${date.month}${date.year}${document['memberId'].toString()}";
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      isThreeLine: true,
                      tileColor: primaryColor.withOpacity(0.06),
                      contentPadding: const EdgeInsets.all(6),
                      horizontalTitleGap: 8,
                      leading: CircleAvatar(
                        backgroundColor: greyColor.withOpacity(0.2),
                        radius: 30.0,
                        child: document['memberImgUrl'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  document['memberImgUrl'],
                                  fit: BoxFit.fill,
                                ),
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
                          Text("Employee Id: $empId"),
                          const SizedBox(height: 2),
                          Text("Designation: ${document['designation']}"),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Joining',
                            style: TextStyle(
                              color: defaultColor.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            'Date',
                            style: TextStyle(
                              color: defaultColor.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${date.day}-${date.month}-${date.year}",
                            style: TextStyle(
                              color: defaultColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
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
              builder: (context) => const AddEmployeeScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        elevation: 8,
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}
