import 'package:auhackathon/models/expense_model.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:auhackathon/services/firestore_services.dart';
import 'package:auhackathon/add_functionss/add_expense.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendExpensePage extends StatefulWidget {
  final UserModel friend;
  const FriendExpensePage({
    super.key,
    required this.friend,
  });
  @override
  State<FriendExpensePage> createState() => _FriendExpensePageState();
}

class _FriendExpensePageState extends State<FriendExpensePage> {
  UserModel? friend;
  final FirestoreService firestoreService = FirestoreService();
  final curuserid = FirebaseAuth.instance.currentUser!.uid;
  late double netExpenses;
  @override
  void initState() {
    friend = widget.friend;
    netExpenses = 0;
    calculateNetExpenses();
    // Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    //   calculateNetExpenses();
    // });
    super.initState();
  }

  void calculateNetExpenses() async {
    List<ExpenseModel> expenses = (await firestoreService.getExpensesCalc(
      // FirebaseAuth.instance.currentUser!.uid.toString(),
      curuserid.toString(),
      friend!.uid,
    ));

    double userTotal = 0;
    double friendTotal = 0;

    for (var expense in expenses) {
      // print("-----------------------------------------------------");
      // print(expense.amount);
      // if (expense.provideruid == FirebaseAuth.instance.currentUser!.uid) {
      if (expense.provideruid == curuserid) {
        userTotal += double.parse(expense.amount.toString());
      } else {
        friendTotal += double.parse(expense.amount.toString());
      }
    }

    setState(() {
      netExpenses = userTotal - friendTotal;
    });
  }

  void reloadBody() {
    calculateNetExpenses();
  }

  Future<void> _deleteExpense(ExpenseModel expense) async {
    await firestoreService.deleteExpense(
        curuserid, friend!.uid, expense.expenseId);
    reloadBody();
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteExpense(expense);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        title: friend!.username,
        // url: friend!.profileImageUrl,
        leading: friend!.profileImageUrl == ""
            ? const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 236, 188, 249),
                radius: 24,
                child: Icon(Icons.person),
              )
            : CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(friend!.profileImageUrl),
                radius: 24,
              ),
        onReload: reloadBody,
      ),
      body: Stack(
        children: [
          const Image(
            height: double.maxFinite,
            width: double.maxFinite,
            image: AssetImage('assets/images/bgimg2.png'),
            fit: BoxFit.cover,
            // color: Colors.black,//background color most probably
          ),
          Column(
            children: [
              // const SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    color: const Color.fromARGB(255, 246, 213, 173),
                    padding: const EdgeInsets.all(8),
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
                        : netExpenses < 0
                            ? Center(
                                child: Text(
                                  "You will pay ${-1 * netExpenses}₹",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : friend!.uid == curuserid
                                ? Center(
                                    child: Text(
                                      "You Spent $netExpenses₹",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.green,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "You will recieve $netExpenses₹",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder<List<ExpenseModel>>(
                  stream: firestoreService.getExpenses(
                      // FirebaseAuth.instance.currentUser!.uid.toString(),
                      curuserid.toString(),
                      friend!.uid), // Replace with the actual user ID
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: expense.provideruid ==
                                      // FirebaseAuth.instance.currentUser!.uid
                                      curuserid
                                  ? const Color.fromARGB(255, 246, 173, 173)
                                  : Colors.greenAccent,
                              child: ListTile(
                                leading: expense.provideruid == curuserid
                                    ? const Icon(Icons.subdirectory_arrow_left)
                                    : const Icon(
                                        Icons.subdirectory_arrow_right),
                                title: Text(expense.about),
                                subtitle: Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        expense.date),
                                  ),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(expense.amount.toString()),
                                onLongPress: () {
                                  _showDeleteConfirmationDialog(
                                      context, expense);
                                },
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseInput(
                friend: friend!,
              ),
            ),
          );
        },
        buttonWidth: 180,
        backgroundColor: hexStringToColor("9546C4"),
        text: "Add Expense",
        icon: Icons.book,
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
