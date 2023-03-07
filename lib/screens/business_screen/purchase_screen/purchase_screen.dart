import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/widgets/border_form_field.dart';

import '../items_screen/add_item_screen.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  DateTime _selectedInvoiceDate = DateTime.now();
  bool? _isPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            stretch: true,
            title: Text(
              "Purchase",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2 - 24,
                        child: Column(
                          children: const [
                            Text(
                              'Bill No.',
                            ),
                            SizedBox(height: 8),
                            BorderFormField(
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.none,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2 - 24,
                        child: Column(
                          children: [
                            const Text(
                              'Date',
                            ),
                            const SizedBox(height: 8),
                            BorderFormField(
                              //autofocus: false,
                              readOnly: true,
                              controller: _invoiceDateController,
                              obscureText: false,
                              textAlign: TextAlign.center,
                              textCapitalization: TextCapitalization.none,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedInvoiceDate,
                                  firstDate: DateTime(2022, 10),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null &&
                                    pickedDate != _selectedInvoiceDate) {
                                  setState(() {
                                    _selectedInvoiceDate = pickedDate;
                                    _invoiceDateController.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                  });
                                }
                              },
                              validator: (String? value) {
                                return (value!.isEmpty ||
                                        !RegExp(r'[^-\s][\d-]+$')
                                            .hasMatch(value))
                                    ? "Select valid date"
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 8),
                  Text(
                    'Party details',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 12),
                  BorderFormField(
                    controller: _sellerNameController,
                    lableText: 'Name *',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return (value!.isEmpty ||
                              !RegExp(r'[^-\s][a-z A-Z]+$').hasMatch(value))
                          ? "Please enter valid name"
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BorderFormField(
                    controller: _emailController,
                    lableText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    textCapitalization: TextCapitalization.none,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      return (value!.isEmpty ||
                              (!value.endsWith(
                                    "@gmail.com",
                                  ) &&
                                  !value.endsWith("@yahoo.com")) ||
                              !RegExp(r'[^-\s][a-zA-Z\d]*$').hasMatch(value))
                          ? "Please enter valid email"
                          : null;
                    },
                  ),

                  const SizedBox(height: 16),
                  BorderFormField(
                    controller: _mobileController,
                    lableText: 'Mobile',
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    maxLength: 10,
                    counterText: "",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return (value!.isEmpty ||
                                  !RegExp(r'^\d+$').hasMatch(value)) ||
                              value.length != 10
                          ? "Please enter 10 digit mobile number"
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BorderFormField(
                    controller: _gstController,
                    lableText: 'GST Number',
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 15,
                    counterText: "",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return (value!.isEmpty ||
                                  !RegExp(r'[^-\s][A-Z\d]+$')
                                      .hasMatch(value)) ||
                              value.length != 15
                          ? "Please enter valid GST number"
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item details',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddItemScreen(),
                            ),
                          );
                        },
                        child: const Text("Add item"),
                      ),
                    ],
                  ),

                  Row(
                    children: const [
                      Expanded(
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            'Items',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            'Quantity',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            'Unit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            'Rate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            'Amount',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            'Nandi Gold',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            '200',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            'Bags',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            '910',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            '182000',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            'Jowar',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            '1000',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            'Kgs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            '92',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            '92000',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    height: 2,
                    color: greyColor,
                    indent: MediaQuery.of(context).size.width / 1.38,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Total amount',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '274000',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isPaid,
                              onChanged: (value) {
                                setState(() {
                                  _isPaid = value;
                                });
                              },
                            ),
                            const Text('Paid'),
                          ],
                        ),
                      ),
                      Text(_isPaid == false ? '0' : '274000'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    height: 2,
                    color: greyColor,
                    indent: MediaQuery.of(context).size.width / 1.38,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Balance',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '182000',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
