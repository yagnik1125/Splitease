class UserModel {
  final String username;
  final String uid;
  final String profileImageUrl;
  final String email;
  // final bool active;
  // final int lastSeen;
  // final String phoneNumber;
  // final String about;
  // final String pushToken;
  final List<String> groupId;

  UserModel({
    required this.username,
    required this.uid,
    required this.profileImageUrl,
    required this.email,
    // required this.active,
    // required this.lastSeen,
    // required this.phoneNumber,
    // required this.about,
    // required this.pushToken,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'profileImageUrl': profileImageUrl,
      'email': email,
      // 'active': active,
      // 'lastSeen': lastSeen,
      // 'phoneNumber': phoneNumber,
      // 'about': about,
      // 'pushToken': pushToken,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      email: map['email'] ?? '',
      // active: map['active'] ?? false,
      // lastSeen: map['lastSeen'] ?? 0,
      // phoneNumber: map['phoneNumber'] ?? '',
      // about: map['about'] ?? '',
      // pushToken: map['pushToken'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}
