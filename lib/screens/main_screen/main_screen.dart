import 'package:flutter/material.dart';
import 'package:vfpcl/screens/business_screen/business_screen.dart';
import 'package:vfpcl/screens/home_screen/home_screen.dart';
import 'package:vfpcl/screens/profile_screen/profile_screen.dart';
import 'package:vfpcl/screens/services_screen/services_screen.dart';
import 'package:vfpcl/screens/staff_screen/staff_screen.dart';

import '../../constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabIndex = 0;

  final List<Widget> _tabs = [
    const HomeScreen(appBarTitle: "Home"),
    const StaffScreen(appBarTitle: "Staff"),
    const BusinessScreen(appBarTitle: "Business"),
    const ServicesScreen(appBarTitle: "Services"),
    const ProfileScreen(appBarTitle: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        currentIndex: _currentTabIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: greyColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: "Staff",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory_outlined),
            label: "Business",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel_outlined),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}
