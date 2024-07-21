import 'package:auhackathon/add_functionss/creategroup.dart';
import 'package:auhackathon/models/group_expense_model.dart';
import 'package:auhackathon/models/group_model.dart';
import 'package:auhackathon/services/firestore_services.dart';
import 'package:auhackathon/userpages/groupexpensepage.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final FirestoreService _firestoreService = FirestoreService();

  Future<double> calculateNetExpense(GroupModel group) async {
    FirestoreService firestoreService = FirestoreService();
    String curUserId = FirebaseAuth.instance.currentUser!.uid;
    List<GroupExpenseModel> expenses =
        await firestoreService.getGroupExpensesForCalc(
      group.groupid,
    );
    // double userTotal = 0;
    // double friendTotal = 0;
    // for (var expense in expenses) {
    //   if (expense.provideruid == curUserId) {
    //     userTotal += double.parse(expense.amount.toString());
    //   } else {
    //     friendTotal += double.parse(expense.amount.toString());
    //   }
    // }
    // return userTotal - friendTotal;

    Map<String, double> netAmountMap = {};
    double len = group.members.length.toDouble();

    // double userTotal = 0;
    // double friendTotal = 0;

    for (var expense in expenses) {
      // print("-----------------------------------------------------");
      // print(expense.amount);
      // if (expense.provideruid == FirebaseAuth.instance.currentUser!.uid) {
      // if (expense.provideruid == curuserid) {
      //   userTotal += double.parse(expense.amount.toString());
      // } else {
      //   friendTotal += double.parse(expense.amount.toString());
      // }
      double amount = double.parse(expense.amount.toString());
      if (expense.receiverUid == "Split") {
        netAmountMap.update(
          expense.provideruid,
          (value) => value - len * amount,
          ifAbsent: () => -len * amount,
        );

        for (var member in group.members) {
          netAmountMap.update(
            member.uid,
            (value) => value + amount,
            ifAbsent: () => amount,
          );
        }
      } else {
        netAmountMap.update(
          expense.provideruid,
          (value) => value - amount,
          ifAbsent: () => -amount,
        );
        netAmountMap.update(
          expense.receiverUid,
          (value) => value + amount,
          ifAbsent: () => amount,
        );
      }

      // print("amount:$amount");
    }
    return netAmountMap[curUserId]!;
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold();

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 210) / 2,
              ),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateGroup()));
                },
                buttonWidth: 210,
                backgroundColor: hexStringToColor("9546C4"),
                text: "Create Groups",
                icon: Icons.person,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 210) / 2 - 50,
              ),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.replay)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<List<GroupModel>>(
              stream: _firestoreService.getGroups(FirebaseAuth
                  .instance.currentUser!.uid
                  .toString()), // Replace with the actual user ID
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No groups found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final group = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: const Color.fromARGB(255, 177, 236, 243),
                          child: ListTile(
                            title: Text(group.groupname),
                            subtitle: Text('Members: ${group.members.length}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GroupExpensePage(group: group),
                                ),
                              );
                            },
                            trailing: FutureBuilder<double>(
                              future: calculateNetExpense(group),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  double netExpense = snapshot.data ?? 0;
                                  // String netExpenseText = netExpense >= 0
                                  //     ? "You will receive $netExpense₹"
                                  //     : "You will give ${-netExpense}₹";

                                  return netExpense == 0
                                      ? const Text(
                                          "0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          (netExpense * (-1.0)).toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: netExpense < 0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        );
                                }
                              },
                            ),
                            // Add more details as needed
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
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
