import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'items_screen/items_screen.dart';
import 'parties_screen/parties_screen.dart';
import 'transactions_screen/transactions_screen.dart';

class BusinessScreen extends StatefulWidget {
  final String appBarTitle;
  const BusinessScreen({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
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
                child: Text("Parties"),
              ),
              Tab(
                child: Text("Transactions"),
              ),
              Tab(
                child: Text("Items"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PartiesScreen(),
            TransactionsScreen(),
            ItemsScreen(),
          ],
        ),
      ),
    );
  }
}
