import 'package:flutter/material.dart';
import 'package:vfpcl/screens/board_screen/board_screen.dart';
import 'package:vfpcl/screens/dashboard_screen/dashboard_screen.dart';
import 'package:vfpcl/screens/members_screen/members_screen.dart';

import '../../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  final String appBarTitle;
  const HomeScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 1,
            labelColor: primaryColor,
            unselectedLabelColor: greyColor,
            tabs: [
              Tab(
                child: Text("Dashboard"),
              ),
              Tab(
                child: Text("Members"),
              ),
              Tab(
                child: Text("Board"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DashboardScreen(),
            MembersScreen(),
            BoardScreen(),
          ],
        ),
      ),
    );
  }
}
