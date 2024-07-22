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
  List<UserModel> selectedMembers =
      []; // List to keep track of selected members

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

  Future<UserModel> getCurrentUserModel() async {
    // You should replace this with the actual logic to fetch the current user's UserModel
    // This is just a placeholder implementation
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    UserModel currentUserModel = widget.groupMembers.firstWhere((member) => member.uid == currentUserUid);
    return currentUserModel;
  }

  Future<void> addExpense({bool split = false}) async {
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
    } else if (selectedMembers.isEmpty) {
      showAlertDialog(
          context: context, message: "Select at least one member to pay to");
      return;
    }

    double amount = double.parse(_amountController.text);
    String description = _descriptionController.text;
    String providerUid = FirebaseAuth.instance.currentUser!.uid;
    if (split) {
      UserModel currentUser = await getCurrentUserModel();
      if (!selectedMembers.contains(currentUser)) {
        selectedMembers.add(currentUser);
      }
    }

    List<String> receiverUids =
        selectedMembers.map((member) => member.uid).toList();
    double len = double.parse(selectedMembers.length.toString());

    if (split) {
      amount = amount / len;
    }

    ref.read(expenseControllerProvider).addGroupExpenseToFirebase(
          expenseId: const Uuid().v1(),
          groupId: widget.groupId,
          amount: amount,
          about: description,
          providerUid: providerUid,
          recieverUid: receiverUids,
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
            Expanded(
              child: ListView.builder(
                itemCount: widget.groupMembers.length,
                itemBuilder: (context, index) {
                  final member = widget.groupMembers[index];
                  return CheckboxListTile(
                    title: Text(member.username),
                    value: selectedMembers.contains(member),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedMembers.add(member);
                        } else {
                          selectedMembers.remove(member);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => addExpense(split: true),
                  child: const Text('Split Expense'),
                ),
                ElevatedButton(
                  onPressed: addExpense,
                  child: const Text('Add Expense'),
                ),
              ],
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
