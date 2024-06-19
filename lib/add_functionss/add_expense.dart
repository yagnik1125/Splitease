import 'package:auhackathon/controller/expense_controller.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:auhackathon/widgets/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ExpenseInput extends ConsumerStatefulWidget {
  final UserModel friend;
  const ExpenseInput({super.key, required this.friend});
  @override
  ConsumerState<ExpenseInput> createState() => _ExpenseInputState();
}

class _ExpenseInputState extends ConsumerState<ExpenseInput> {
  UserModel? friend;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    friend = widget.friend;
    super.initState();
  }

  final List<String> dropdownItems = [
    'you paid split equally',
    'other paid split equally',
    'you paid full amount',
    'other paid full amount'
  ];
  String? selectedDropdownItem;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      });
    }
  }

  addExpense() {
    if (_amountController.text.isEmpty) {
      showAlertDialog(context: context, message: "Enter Amount");
      return;
    } else if (_descriptionController.text.isEmpty) {
      showAlertDialog(context: context, message: "Enter the Description");
      return;
    } else if (selectedDate == null) {
      showAlertDialog(context: context, message: "Select the date");
      return;
    } else if (selectedDropdownItem == null) {
      showAlertDialog(context: context, message: "Select the expense type");
      return;
    }

    double amount = double.parse(_amountController.text.toString());
    String description = _descriptionController.text;
    dynamic providerUid = FirebaseAuth.instance.currentUser!.uid.toString();
    dynamic recieverUid = friend!.uid;

    if (selectedDropdownItem == 'you paid split equally') {
      amount = amount / 2;
    } else if (selectedDropdownItem == 'other paid split equally') {
      amount = amount / 2;
      //-----swap-----------------
      dynamic temp = providerUid;
      providerUid = recieverUid;
      recieverUid = temp;
    } else if (selectedDropdownItem == 'other paid full amount') {
      //-----swap-----------------
      dynamic temp = providerUid;
      providerUid = recieverUid;
      recieverUid = temp;
    }

    ref.read(expenseControllerProvider).addExpenseToFirebase(
        expenseType: selectedDropdownItem!,
        date: selectedDate!,
        amount: amount,
        about: description,
        providerUid: providerUid,
        recieverUid: recieverUid,
        expenseId: const Uuid().v1(),
        context: context,
        mounted: mounted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        // backgroundColor: Colors.blue,
        gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        title: 'Expense',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Amount Input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 16.0),

            // Description Input
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16.0),

            TextFormField(
              onTap: () => _selectDate(context),
              readOnly: true,
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16.0),

            // Dropdown Input
            DropdownButton<String>(
              hint: const Text('Select an option'),
              value: selectedDropdownItem,
              onChanged: (value) {
                setState(() {
                  selectedDropdownItem = value;
                });
              },
              items: dropdownItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16.0),

            // Save Button
            ElevatedButton(
              onPressed: () {
                addExpense();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient gradient;
  // final dynamic leading;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    // this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: AppBar(
        // leading: leading,
        title: Text(
          title,
          style: const TextStyle(
            // fontFamily: 'Pacifico',
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //     },
        //     icon: const Icon(Icons.logout),
        //   ),
        // ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16.0);
}

class CustomElevatedButton extends StatelessWidget {
  final double? buttonWidth;
  final VoidCallback onPressed;
  final dynamic backgroundColor;
  final String text;
  final dynamic icon;
  const CustomElevatedButton(
      {Key? key,
      this.buttonWidth,
      required this.onPressed,
      this.backgroundColor,
      required this.text,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      width: buttonWidth ?? MediaQuery.of(context).size.width - 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
