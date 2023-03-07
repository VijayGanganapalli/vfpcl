import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vfpcl/constants/colors.dart';

import 'add_product_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor.withOpacity(0.05),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('fpcs')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('products')
              .orderBy("quantity", descending: true)
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
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'There is no product available',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              var format =
                  NumberFormat.currency(symbol: '₹ ', decimalDigits: 0);
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  final date = DateTime.parse(
                      document['invoiceDate'].toDate().toString());
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Card(
                      elevation: 2,
                      shadowColor: primaryColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.all(8),
                        childrenPadding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        expandedAlignment: Alignment.topLeft,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        collapsedBackgroundColor:
                            primaryColor.withOpacity(0.06),
                        textColor: defaultColor.withOpacity(0.4),
                        backgroundColor: primaryColor.withOpacity(0.06),
                        controlAffinity: ListTileControlAffinity.platform,
                        leading: CircleAvatar(
                          backgroundColor: greyColor.withOpacity(0.2),
                          radius: 30.0,
                          child: document['productImgUrl'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    document['productImgUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : const Icon(Icons.person,
                                  size: 45, color: greyColor),
                        ),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(document['productName']),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 1.2,
                                height: 12,
                                color: defaultColor.withOpacity(0.4),
                              ),
                            ),
                            Text(
                              document['productCategory'],
                              style: TextStyle(
                                color: defaultColor.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Available quantity: ${document['quantity']}'),
                            const SizedBox(height: 2),
                            Text(
                                'Buy rate: ${format.format(document['ratePerUnit'])}/${document['unit']}'),
                          ],
                        ),
                        children: [
                          Row(
                            children: [
                              Text(
                                "Invoice No: ",
                                style: TextStyle(
                                  color: defaultColor.withOpacity(0.4),
                                ),
                              ),
                              Text("${document['invoiceNumber']}"),
                              Visibility(
                                visible: document['vehicleNumber']
                                    .toString()
                                    .isNotEmpty,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Container(
                                    width: 1.2,
                                    height: 10,
                                    color: defaultColor.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: document['vehicleNumber']
                                    .toString()
                                    .isNotEmpty,
                                child: Row(
                                  children: [
                                    Text(
                                      "Vehicle No: ",
                                      style: TextStyle(
                                        color: defaultColor.withOpacity(0.4),
                                      ),
                                    ),
                                    Text("${document['vehicleNumber']}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Invoice date: ",
                                style: TextStyle(
                                  color: defaultColor.withOpacity(0.4),
                                  height: 1.4,
                                ),
                              ),
                              Text("${date.day}-${date.month}-${date.year}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Seller: ",
                                style: TextStyle(
                                  height: 1.4,
                                  color: defaultColor.withOpacity(0.4),
                                ),
                              ),
                              Text("${document['sellerName']}"),
                            ],
                          ),
                          Text(
                            "${document['sellerAddress']}",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.4,
                              color: defaultColor.withOpacity(0.4),
                            ),
                          ),
                          Visibility(
                            visible: document['sellerGstNumber']
                                .toString()
                                .isNotEmpty,
                            child: Row(
                              children: [
                                Text(
                                  "Seller GST: ",
                                  style: TextStyle(
                                    height: 1.4,
                                    color: defaultColor.withOpacity(0.4),
                                  ),
                                ),
                                Text("${document['sellerGstNumber']}"),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Buyer: ",
                                style: TextStyle(
                                  height: 1.4,
                                  color: defaultColor.withOpacity(0.4),
                                ),
                              ),
                              Text("${document['buyerName']}"),
                            ],
                          ),
                          Text(
                            "${document['buyerAddress']}",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.4,
                              color: defaultColor.withOpacity(0.4),
                            ),
                          ),
                          Visibility(
                            visible: document['buyerGstNumber']
                                .toString()
                                .isNotEmpty,
                            child: Row(
                              children: [
                                Text(
                                  "Buyer GST: ",
                                  style: TextStyle(
                                    height: 1.4,
                                    color: defaultColor.withOpacity(0.4),
                                  ),
                                ),
                                Text("${document['buyerGstNumber']}"),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Remove",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        color: primaryColor,
                                      ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Edit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        color: primaryColor,
                                      ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Sale",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        color: primaryColor,
                                      ),
                                ),
                              ),
                            ],
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
              builder: (context) => const AddProductScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        elevation: 8,
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
