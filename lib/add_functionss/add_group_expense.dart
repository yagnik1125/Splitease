import 'package:auhackathon/controller/expense_controller.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:auhackathon/widgets/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class GroupExpenseInput extends ConsumerStatefulWidget {
  final String groupId;
  final List<UserModel> groupMembers;

  const GroupExpenseInput({
    super.key,
    required this.groupId,
    required this.groupMembers,
  });

  @override
  ConsumerState<GroupExpenseInput> createState() => _GroupExpenseInputState();
}

class _GroupExpenseInputState extends ConsumerState<GroupExpenseInput> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;
  UserModel? selectedMember; // Selected member to pay to

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
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

  void addExpense() {
    // print("_amountController.text-------->${_amountController.text}");
    // print("_descriptionController.text-------->${_descriptionController.text}");
    // print("selectedDate-------->$selectedDate");
    // if (selectedMember != null)
    //   print("selectedMember-------->${selectedMember!.username}");
    // else
    //   print("Split");

    if (_amountController.text.isEmpty) {
      showAlertDialog(context: context, message: "Enter Amount");
      return;
    } else if (_descriptionController.text.isEmpty) {
      showAlertDialog(context: context, message: "Enter the Description");
      return;
    } else if (selectedDate == null) {
      showAlertDialog(context: context, message: "Select the date");
      return;
    }
    // else if (selectedMember == null) {
    //   showAlertDialog(context: context, message: "Select the member to pay to");
    //   return;
    // }

    double amount = double.parse(_amountController.text);
    String description = _descriptionController.text;
    String providerUid = FirebaseAuth.instance.currentUser!.uid;
    String recieverUid = selectedMember != null ? selectedMember!.uid : "Split";

    // If the expense is split equally
    if (recieverUid == "Split") {
      amount = amount / (widget.groupMembers.length);
      // recieverUid = ""; // No specific receiver for split expense
    }

    ref.read(expenseControllerProvider).addGroupExpenseToFirebase(
          expenseId: const Uuid().v1(),
          groupId: widget.groupId,
          amount: amount,
          about: description,
          providerUid: providerUid,
          recieverUid: recieverUid,
          date: selectedDate!,
          context: context,
          mounted: mounted,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        title: 'Add Expense',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 16.0),
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
            DropdownButton<UserModel>(
              hint: const Text('Select member to pay to'),
              value: selectedMember,
              onChanged: (UserModel? value) {
                setState(() {
                  selectedMember = value;
                });
              },
              items: widget.groupMembers
                  .map((UserModel member) => DropdownMenuItem<UserModel>(
                        value: member,
                        child: Text(member.username),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addExpense,
              child: const Text('Add Expense'),
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

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16.0);
}
