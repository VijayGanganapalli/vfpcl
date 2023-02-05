import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor.withOpacity(0.08),
      body: ListView.builder(
        itemCount: 5,
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
                      const Text("Chairman"),
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
                        "Duration: ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const Text("Jan 2023 - 2028"),
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
    );
  }
}
