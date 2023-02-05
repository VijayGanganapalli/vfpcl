import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  final String appBarTitle;
  const ServicesScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
    );
  }
}
