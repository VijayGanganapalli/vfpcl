import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({Key? key}) : super(key: key);

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor.withOpacity(0.08),
      body: ListView(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        children: [
          Card(
            elevation: 4,
            color: primaryColor,
            shadowColor: primaryColor.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: greyColor.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Employees information",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: backgroundColor,
                            letterSpacing: 0.8,
                          ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.95),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total working employees',
                            style: TextStyle(
                              color: defaultColor.withOpacity(0.4),
                              height: 2.5,
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('fpcs')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('employees')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Error");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: backgroundColor,
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: defaultColor.withOpacity(0.4),
                                    ),
                                  );
                                }
                                return SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    color: defaultColor.withOpacity(0.4),
                                  ),
                                );
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total working female employees',
                            style: TextStyle(
                              color: defaultColor.withOpacity(0.4),
                              height: 2.2,
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('fpcs')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('employees')
                                  .where('gender', isEqualTo: 'Female')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Error");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: backgroundColor,
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: defaultColor.withOpacity(0.4),
                                    ),
                                  );
                                }
                                return SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    color: defaultColor.withOpacity(0.4),
                                  ),
                                );
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total working male employees',
                            style: TextStyle(
                              color: defaultColor.withOpacity(0.4),
                              height: 2.2,
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('fpcs')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('employees')
                                  .where('gender', isEqualTo: 'Male')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Error");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: backgroundColor,
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: defaultColor.withOpacity(0.4),
                                    ),
                                  );
                                }
                                return SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    color: defaultColor.withOpacity(0.4),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
