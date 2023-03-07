import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? memImgUrl;
  String? fullName;
  String? surname;
  String? gender;
  String? maritalStatus;
  String? fatherOrHusbandName;
  int? aadhar;
  int? mobileNumber;
  String? dob;
  double? landHolding;
  String? state;
  String? district;
  String? mandal;
  String? gramaPanchayati;
  String? habitation;
  String? joiningDate;
  int? membership;
  int? shareCapital;

  Future<int> getMemberCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('fpos')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('members')
        .get();
    return snapshot.size;
  }

  getFpoData() async {
    return await FirebaseFirestore.instance
        .collection('fpos')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      snapshot.data()!['regNum'];
    });
  }

  getRelationship() => (gender == "Female" && maritalStatus == "Married")
      ? "Husband name"
      : "Father name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            stretch: true,
            title: Text(
              'Product Details',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // implement edit member info function
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('fpcs')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('products')
                  .doc(widget.productId)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Center(child: Text("Error: ${snapshot.error}")),
                  );
                }
                if (snapshot.hasData) {
                  DocumentSnapshot docSnapshot = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(docSnapshot['productName']),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
