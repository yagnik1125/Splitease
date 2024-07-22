import 'package:auhackathon/add_functionss/add_group_expense.dart';
import 'package:auhackathon/add_functionss/addfriendtogroup.dart';
import 'package:auhackathon/models/group_expense_model.dart';
import 'package:auhackathon/models/group_model.dart';
import 'package:auhackathon/services/firestore_services.dart';
import 'package:auhackathon/userpages/settledebtpage.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupExpensePage extends StatefulWidget {
  final GroupModel group;
  const GroupExpensePage({super.key, required this.group});

  @override
  State<GroupExpensePage> createState() => _GroupExpensePageState();
}

class _GroupExpensePageState extends State<GroupExpensePage> {
  GroupModel? group;
  final FirestoreService firestoreService = FirestoreService();
  final curuserid = FirebaseAuth.instance.currentUser!.uid;
  late double netExpenses;
  Map<String, double> netAmountMap = {};

  @override
  void initState() {
    group = widget.group;
    netExpenses = 0;
    super.initState();
    calculateNetExpenses();
  }

  void calculateNetExpenses() async {
    List<GroupExpenseModel> expenses =
        (await firestoreService.getGroupExpensesForCalc(
      // FirebaseAuth.instance.currentUser!.uid.toString(),
      group!.groupid,
    ));

    // double len = group!.members.length.toDouble();

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
      double len = expense.receiverUid.length.toDouble();
      if (len >= 2) {
        netAmountMap.update(
          expense.provideruid,
          (value) => value - len * amount,
          ifAbsent: () => -len * amount,
        );

        for (var memberId in expense.receiverUid) {
          netAmountMap.update(
            memberId,
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
          expense.receiverUid[0],
          (value) => value + amount,
          ifAbsent: () => amount,
        );
      }

      // print("amount:$amount");
    }

    // for (var entry in netAmountMap.entries) {
    //   print('User ID: ${entry.key}, Net Expense: ${entry.value}');
    // }

    setState(() {
      netExpenses = netAmountMap[curuserid]!;
    });
  }

  void reloadBody() {
    calculateNetExpenses();
  }

  String getUserNameById(String uid) {
    final user = widget.group.members.firstWhere((member) => member.uid == uid);
    return user.username;
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
        title: group!.groupname,
        // // url: friend!.profileImageUrl,
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 236, 188, 249),
          radius: 24,
          child: Icon(Icons.groups),
        ),
        onReload: reloadBody,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFriendToGroup(
                          groupId: group!.groupid,
                        ),
                      ),
                    );
                  },
                  buttonWidth: 180,
                  backgroundColor: hexStringToColor("9546C4"),
                  text: "Add Friend",
                  icon: Icons.person,
                ),
                const Spacer(), // Add a spacer to distribute space evenly
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupExpenseInput(
                          groupId: group!.groupid,
                          groupMembers: group!.members,
                        ),
                      ),
                    );
                  },
                  buttonWidth: 180,
                  backgroundColor: hexStringToColor("9546C4"),
                  text: "Add Expense",
                  icon: Icons.book,
                ),
              ],
            ),
          ),
          // ------------------------------------------------------------------
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                color: const Color.fromARGB(255, 246, 213, 173),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: netExpenses == 0
                          ? const Center(
                              child: Text(
                                "Net Expense 0₹",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : netExpenses > 0
                              ? Center(
                                  child: Text(
                                    "You will pay $netExpenses₹",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "You will recieve ${-1 * netExpenses}₹",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SettleDebtPage(netAmountMap: netAmountMap,group: widget.group,),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // ------------------------------
          Expanded(
            child: StreamBuilder<List<GroupExpenseModel>>(
              stream: firestoreService.getExpensesForGroup(group!.groupid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Expense found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final expense = snapshot.data![index];
                      final providerName = getUserNameById(expense.provideruid);
                      final receivers = expense.receiverUid;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: const Color.fromARGB(255, 173, 235, 246),
                          child: ListTile(
                            // leading: expense.provideruid == curuserid
                            //     ? const Icon(Icons.subdirectory_arrow_left)
                            //     : const Icon(Icons.subdirectory_arrow_right),
                            title: Text(
                              expense.about,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        expense.date),
                                  ),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Text(
                                      'Provider: $providerName',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Type: ${receivers.length > 1 ? "Split" : "Personal"}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // subtitle: Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       DateFormat('dd/MM/yyyy').format(
                            //         DateTime.fromMillisecondsSinceEpoch(
                            //             expense.date),
                            //       ),
                            //       style: const TextStyle(
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //     const SizedBox(height: 5.0),
                            //     Text(
                            //       'Provider: $providerName',
                            //       style: const TextStyle(
                            //           fontStyle: FontStyle.italic),
                            //     ),
                            //     Text(
                            //       'Type: ${receivers.length > 1 ? "Split" : "Personal"}',
                            //       style: const TextStyle(
                            //           fontStyle: FontStyle.italic),
                            //     ),
                            //   ],
                            // ),
                            trailing: Text(expense.amount.toString()),
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             FriendExpensePage(friend: friend)));
                            },
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

class GradientAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient gradient;
  final VoidCallback onReload;
  final dynamic leading;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    required this.onReload,
    required this.leading,
  });

  @override
  State<GradientAppBar> createState() => _GradientAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 26.0);
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: widget.gradient,
      ),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.leading,
            SizedBox(
              width: MediaQuery.of(context).size.width / 8,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 26,
              ),
            ),
          ],
        ),
        // leading: CircleAvatar(
        //   backgroundImage: CachedNetworkImageProvider(widget.url),
        //   radius: 24,
        // ),
        // leading: InkWell(child: widget.leading,onTap: Navigator.pop(context),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              widget.onReload();
            },
            icon: const Icon(Icons.replay_outlined),
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
