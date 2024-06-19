import 'package:auhackathon/controller/friend_controller.dart';
import 'package:auhackathon/services/firestore_services.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFriend extends ConsumerStatefulWidget {
  const AddFriend({super.key});
  @override
  ConsumerState<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends ConsumerState<AddFriend> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _searchResults = [];

  void _performSearch() async {
    final String searchTerm = _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      final List<Map<String, dynamic>> results =
          await _firestoreService.searchUsers(searchTerm);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void addFriend(String fId) {
    ref.read(friendControllerProvider).addFriendToFirebase(
          hostUserUid: FirebaseAuth.instance.currentUser!.uid.toString(),
          friendUserUid: fId,
          // ref: ref,
          context: context,
          mounted: mounted,
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
        title: "SplitEase",
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by username',
              ),
              onChanged: (value) {
                _performSearch();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: const Color.fromARGB(255, 190, 238, 243),
                    child: user['profileImageUrl'] == ""
                        ? ListTile(
                            leading: const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 236, 188, 249),
                              child: Icon(Icons.person),
                              // backgroundImage: CachedNetworkImageProvider(
                              //     friend.profileImageUrl),
                              // radius: 24,
                            ),
                            title: Text(user['username']),
                            subtitle: Text(user['email']),
                            onTap: () {
                              addFriend(user['uid']);
                            },
                            // Add more details as needed
                          )
                        : ListTile(
                            leading: CircleAvatar(
                              // backgroundColor:
                              //     Color.fromARGB(255, 236, 188, 249),
                              // child: Icon(Icons.person),
                              backgroundImage: CachedNetworkImageProvider(
                                  user['profileImageUrl']),
                              radius: 24,
                            ),
                            title: Text(user['username']),
                            subtitle: Text(user['email']),
                            onTap: () {
                              addFriend(user['uid']);
                            },
                            // Add more details as needed
                          ),
                  ),
                );
              },
            ),
          ),
        ],
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
            fontFamily: 'Pacifico',
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
        //       FirebaseAuth.instance.signOut().then((value) {
        //         print("Signed Out");
        //         Navigator.pushReplacement(context,
        //             MaterialPageRoute(builder: (context) => const Login()));
        //       });
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
