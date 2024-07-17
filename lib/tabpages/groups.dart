// import 'package:auhackathon/models/usermodel.dart';
// import 'package:auhackathon/services/firestore_services.dart';
// import 'package:auhackathon/widgets/color_utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // final FirestoreService _firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold();
    
    // return Scaffold(
    //   body: Column(
    //     children: [
    //       const SizedBox(
    //         height: 10,
    //       ),
    //       CustomElevatedButton(
    //         onPressed: () {
    //           // Navigator.push(context,
    //           //     MaterialPageRoute(builder: (context) => const AddFriend()));
    //         },
    //         buttonWidth: 210,
    //         backgroundColor: hexStringToColor("9546C4"),
    //         text: "Add more Groups",
    //         icon: Icons.person,
    //       ),
    //       const SizedBox(
    //         height: 10,
    //       ),
    //       Expanded(
    //         child: StreamBuilder<List<UserModel>>(
    //           stream: _firestoreService.getFriends(FirebaseAuth
    //               .instance.currentUser!.uid
    //               .toString()), // Replace with the actual user ID
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return const Center(child: CircularProgressIndicator());
    //             } else if (snapshot.hasError) {
    //               return Center(child: Text('Error: ${snapshot.error}'));
    //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //               return const Center(child: Text('No friends found.'));
    //             } else {
    //               return ListView.builder(
    //                 itemCount: snapshot.data!.length,
    //                 itemBuilder: (context, index) {
    //                   final friend = snapshot.data![index];
    //                   return Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                         vertical: 5.0, horizontal: 10.0),
    //                     child: Card(
    //                       elevation: 2.0,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(10.0),
    //                       ),
    //                       color: const Color.fromARGB(255, 177, 236, 243),
    //                       child: friend.profileImageUrl == ""
    //                           ? ListTile(
    //                               leading: const CircleAvatar(
    //                                 backgroundColor:
    //                                     Color.fromARGB(255, 236, 188, 249),
    //                                 child: Icon(Icons.person),
    //                                 // backgroundImage: CachedNetworkImageProvider(
    //                                 //     friend.profileImageUrl),
    //                                 // radius: 24,
    //                               ),
    //                               title: Text(friend.username),
    //                               subtitle: Text(friend.email),
    //                               onTap: () {
    //                                 // Navigator.push(
    //                                 //     context,
    //                                 //     MaterialPageRoute(
    //                                 //         builder: (context) =>
    //                                 //             FriendExpensePage(
    //                                 //                 friend: friend)));
    //                               },
    //                               // Add more details as needed
    //                             )
    //                           : ListTile(
    //                               // leading: CircleAvatar(
    //                               //   // backgroundColor:
    //                               //   //     Color.fromARGB(255, 236, 188, 249),
    //                               //   // child: Icon(Icons.person),
    //                               //   backgroundImage: CachedNetworkImageProvider(
    //                               //       friend.profileImageUrl),
    //                               //   radius: 24,
    //                               // ),
    //                               title: Text(friend.username),
    //                               subtitle: Text(friend.email),
    //                               onTap: () {
    //                                 // Navigator.push(
    //                                 //     context,
    //                                 //     MaterialPageRoute(
    //                                 //         builder: (context) =>
    //                                 //             FriendExpensePage(
    //                                 //                 friend: friend)));
    //                               },
    //                               // Add more details as needed
    //                             ),
    //                       // ListTile(
    //                       //   // title: Text(snapshot.data![index]),
    //                       //   leading: const CircleAvatar(
    //                       //     backgroundColor: Color.fromARGB(255, 236, 188, 249),
    //                       //     child: Icon(Icons.person),
    //                       //   ),
    //                       //   title: Text(friend.username),
    //                       //   subtitle: Text(friend.email),
    //                       //   // Add more details as needed
    //                       // );
    //                     ),
    //                   );
    //                 },
    //               );
    //             }
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
