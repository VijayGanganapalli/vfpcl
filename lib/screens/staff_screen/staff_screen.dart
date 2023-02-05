import 'package:flutter/material.dart';

class StaffScreen extends StatefulWidget {
  final String appBarTitle;
  const StaffScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
    );
  }
}
