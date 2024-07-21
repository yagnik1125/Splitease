import 'package:auhackathon/models/group_model.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:auhackathon/services/firestore_services.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFriendToGroup extends ConsumerStatefulWidget {
  final String groupId;
  const AddFriendToGroup({super.key, required this.groupId});
  @override
  ConsumerState<AddFriendToGroup> createState() => _AddFriendToGroupState();
}

class _AddFriendToGroupState extends ConsumerState<AddFriendToGroup> {
  String? groupId;
  @override
  void initState() {
    groupId = widget.groupId;
    super.initState();
  }

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

  // void addFriendToGroup(String fId) {
  //   ref.read(friendControllerProvider).addFriendToFirebase(
  //         hostUserUid: FirebaseAuth.instance.currentUser!.uid.toString(),
  //         friendUserUid: fId,
  //         // ref: ref,
  //         context: context,
  //         mounted: mounted,
  //       );
  // }

  void addFriendToGroup(UserModel user) async {
    GroupModel? group = await _firestoreService.getGroupById(groupId!);
    if (group != null) {
      List<UserModel> members = List.from(group.members);

      // Check if the user is already in the group
      bool isAlreadyMember = members.any((member) => member.uid == user.uid);

      if (!isAlreadyMember) {
        members.add(user);

        GroupModel updatedGroup = GroupModel(
          groupid: group.groupid,
          groupname: group.groupname,
          members: members,
        );

        await _firestoreService.updateGroup(updatedGroup);
      } else {
        // Optionally show a message that the user is already a member
        print("User is already a member of the group.");
      }
    }
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
                              // addFriendToGroup(user['uid']);
                              UserModel userModel = UserModel.fromMap(user);
                              addFriendToGroup(userModel);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Friend Added to Group')),
                              );
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
                              // addFriendToGroup(user['uid']);
                              UserModel userModel = UserModel.fromMap(user);
                              addFriendToGroup(userModel);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Friend Added to Group')),
                              );
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16.0);
}
