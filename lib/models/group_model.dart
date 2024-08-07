import 'package:auhackathon/models/usermodel.dart';

class GroupModel {
  final String groupname;
  final String groupid;
  final List<UserModel> members;
  // final bool active;
  // final int lastSeen;
  // final String phoneNumber;
  // final String about;
  // final String pushToken;
  // final List<String> groupId;

  GroupModel({
    required this.groupname,
    required this.groupid,
    required this.members,
    // required this.active,
    // required this.lastSeen,
    // required this.phoneNumber,
    // required this.about,
    // required this.pushToken,
    // required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupname': groupname,
      'groupid': groupid,
      'members': members.map((member) => member.toMap()).toList(),
      // 'active': active,
      // 'lastSeen': lastSeen,
      // 'phoneNumber': phoneNumber,
      // 'about': about,
      // 'pushToken': pushToken,
      // 'groupId': groupId,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupname: map['groupname'] ?? '',
      groupid: map['groupid'] ?? '',
      members: List<UserModel>.from(
          map['members']?.map((x) => UserModel.fromMap(x)) ?? []),
      // active: map['active'] ?? false,
      // lastSeen: map['lastSeen'] ?? 0,
      // phoneNumber: map['phoneNumber'] ?? '',
      // about: map['about'] ?? '',
      // pushToken: map['pushToken'] ?? '',
      // groupId: List<String>.from(map['groupId']),
    );
  }
}
