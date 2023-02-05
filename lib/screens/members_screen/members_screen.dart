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
      body: ListView.builder(
        itemCount: 10,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: ListTile(
              minLeadingWidth: 50,
              contentPadding: const EdgeInsets.all(4),
              tileColor: backgroundColor.withOpacity(0.9),
              isThreeLine: true,
              visualDensity: VisualDensity.compact,
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: greyColor.withOpacity(0.1),
                ),
                child: const Icon(Icons.person, size: 32),
              ),
              title: const Text("Vijay Kumar Ganganapalli"),
              subtitle: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("S/o Venkatappa"),
                  Row(
                    children: [
                      Text(
                        "Designation: ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const Text("Member"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Mandal: ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const Text("Lakkireddypalli"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Joining date: ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const Text("12/01/2023"),
                    ],
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 52,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Share",
                    ),
                    const Text(
                      "Holding",
                    ),
                    Text(
                      "100",
                      style: TextStyle(
                        color: defaultColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
