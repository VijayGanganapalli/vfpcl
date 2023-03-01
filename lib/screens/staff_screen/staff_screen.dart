import 'package:flutter/material.dart';
import 'package:vfpcl/screens/staff_screen/employees_screen/employee_screen.dart';
import 'package:vfpcl/screens/staff_screen/staff_dashboard_screen/staff_dashboard_screen.dart';

import '../../constants/colors.dart';

class StaffScreen extends StatefulWidget {
  final String appBarTitle;
  const StaffScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
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
                child: Text("Employees"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StaffDashboardScreen(),
            EmployeeScreen(),
          ],
        ),
      ),
    );
  }
}
