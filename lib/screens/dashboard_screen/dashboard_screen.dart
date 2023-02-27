import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Members information",
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
                  color: greyColor.withOpacity(0.4),
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
                        const Text(
                          'Total members enrolled',
                          style: TextStyle(color: backgroundColor, height: 2.5),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('fpcs')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('members')
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
                                  style:
                                      const TextStyle(color: backgroundColor),
                                );
                              }
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: backgroundColor,
                                ),
                              );
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total female members enrolled',
                          style: TextStyle(color: backgroundColor, height: 2.2),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('fpcs')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('members')
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
                                  style:
                                      const TextStyle(color: backgroundColor),
                                );
                              }
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: backgroundColor,
                                ),
                              );
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total male members enrolled',
                          style: TextStyle(color: backgroundColor, height: 2.2),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('fpcs')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('members')
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
                                  style:
                                      const TextStyle(color: backgroundColor),
                                );
                              }
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: backgroundColor,
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
          const SizedBox(height: 12),
          Column(
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Board members information",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: backgroundColor,
                          letterSpacing: 0.8,
                        ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.4),
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
                        const Text(
                          'Total board members',
                          style: TextStyle(color: backgroundColor, height: 2.5),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('fpcs')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('members')
                                .where('designation', isEqualTo: 'Director')
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
                                  style:
                                      const TextStyle(color: backgroundColor),
                                );
                              }
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: backgroundColor,
                                ),
                              );
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total female board members',
                          style: TextStyle(color: backgroundColor, height: 2.2),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('fpcs')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('members')
                                .where('gender', isEqualTo: 'Female')
                                .where('designation', isEqualTo: 'Director')
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
                                  style:
                                      const TextStyle(color: backgroundColor),
                                );
                              }

                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: backgroundColor,
                                ),
                              );
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total male board members',
                          style: TextStyle(color: backgroundColor, height: 2.2),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('fpcs')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('members')
                                .where('designation', isEqualTo: 'Director')
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
                                  style:
                                      const TextStyle(color: backgroundColor),
                                );
                              }
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: backgroundColor,
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
        ],
      ),
    );
  }
}
