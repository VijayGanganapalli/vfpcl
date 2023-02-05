import 'package:flutter/material.dart';

class BusinessScreen extends StatefulWidget {
  final String appBarTitle;
  const BusinessScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
    );
  }
}
