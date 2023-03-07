import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';

class RentalScreen extends StatefulWidget {
  const RentalScreen({Key? key}) : super(key: key);

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor.withOpacity(0.05),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('fpcs')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('rentals')
              .where('time', isEqualTo: 'Director')
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
                  'There is no rental equipments',
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
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor: primaryColor.withOpacity(0.06),
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          isThreeLine: true,
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
                              Text(
                                  "${document['habitation']}, ${document['revenueVillage']}"),
                              const SizedBox(height: 2),
                              Text(document['mandal']),
                              const SizedBox(height: 2),
                              Text("Designation: ${document['designation']}"),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "ID: ${document['memberId'].toString()}",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: defaultColor.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                "SH: ${document['shareHolding']}",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: defaultColor.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, right: 6),
                          child: Text(
                            "${date.day}-${date.month}-${date.year}",
                            style: TextStyle(
                              fontSize: 12,
                              color: defaultColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 84, right: 6),
                          child: Text(
                            "${document['directorPeriod']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: defaultColor.withOpacity(0.5),
                            ),
                          ),
                        ),
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
    );
  }
}
