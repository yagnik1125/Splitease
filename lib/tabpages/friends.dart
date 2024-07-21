import 'package:auhackathon/add_functionss/addfriend.dart';
import 'package:auhackathon/models/expense_model.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:auhackathon/services/firestore_services.dart';
import 'package:auhackathon/userpages/friendexpensepage.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FirestoreService _firestoreService = FirestoreService();

  //--------------------chat gpt---------------------------
  Future<double> calculateNetExpense(UserModel friend) async {
    FirestoreService firestoreService = FirestoreService();
    String curUserId = FirebaseAuth.instance.currentUser!.uid;
    List<ExpenseModel> expenses = await firestoreService.getExpensesCalc(
      curUserId,
      friend.uid,
    );
    double userTotal = 0;
    double friendTotal = 0;
    for (var expense in expenses) {
      if (expense.provideruid == curUserId) {
        userTotal += double.parse(expense.amount.toString());
      } else {
        friendTotal += double.parse(expense.amount.toString());
      }
    }
    return userTotal - friendTotal;
  }
  //--------------------chat gpt---------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   // child: Text('Friends Page'),
      //   child: CustomElevatedButton(
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => const AddFriend()));
      //     },
      //     buttonWidth: 190,
      //     backgroundColor: hexStringToColor("5E61F4"),
      //     text: "Add more friends",
      //     icon: Icons.person,
      //   ),
      // ),
      body: Stack(
        children: [
          // const Image(
          //   height: double.maxFinite,
          //   width: double.maxFinite,
          //   image: AssetImage('assets/images/bgimg3.jpg'),
          //   fit: BoxFit.cover,
          //   // color: Colors.black,//background color most probably
          // ),
          Column(
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
                              builder: (context) => const AddFriend()));
                    },
                    buttonWidth: 210,
                    backgroundColor: hexStringToColor("5E61F4"),
                    text: "Add more friends",
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
                child: StreamBuilder<List<UserModel>>(
                  stream: _firestoreService.getFriends(FirebaseAuth
                      .instance.currentUser!.uid
                      .toString()), // Replace with the actual user ID
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No friends found.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final friend = snapshot.data![index];

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
                                leading: friend.profileImageUrl == ""
                                    ? const CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 236, 188, 249),
                                        child: Icon(Icons.person),
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                friend.profileImageUrl),
                                        radius: 24,
                                      ),
                                title: friend.uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Text("${friend.username} (You)")
                                    : Text(friend.username),
                                subtitle: Text(friend.email),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FriendExpensePage(friend: friend),
                                    ),
                                  );
                                },
                                trailing: FutureBuilder<double>(
                                  future: calculateNetExpense(friend),
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

                                      return friend.uid ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? Text(
                                              netExpense.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              netExpense.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: netExpense >= 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            );
                                    }
                                  },
                                ),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: CustomElevatedButton(
      //   onPressed: () {},
      //   buttonWidth: 160,
      //   backgroundColor: hexStringToColor("9546C4"),
      //   text: "Add Expense",
      //   icon: Icons.book,
      // ),
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
