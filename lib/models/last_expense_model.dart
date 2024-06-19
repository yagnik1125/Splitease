class LastExpenseModel {
  final String recieveruid;
  final String provideruid;
  final int amount;
  final String about;
  // final String profileImageUrl;
  final DateTime date;
  // final bool active;
  // final int lastSeen;
  // final String phoneNumber;
  // final String about;
  // final String pushToken;
  // final List<String> groupId;

  LastExpenseModel({
    required this.amount,
    required this.recieveruid,
    required this.provideruid,
    required this.date,
    required this.about,
    // required this.username,
    // required this.uid,
    // required this.profileImageUrl,
    // required this.email,
    // required this.active,
    // required this.lastSeen,
    // required this.phoneNumber,
    // required this.about,
    // required this.pushToken,
    // required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'recieveruid': recieveruid,
      'amount': amount,
      // 'profileImageUrl': profileImageUrl,
      'provideruid': provideruid,
      'about': about,
      // 'lastSeen': lastSeen,
      // 'phoneNumber': phoneNumber,
      // 'about': about,
      // 'pushToken': pushToken,
      'date': date,
    };
  }

  factory LastExpenseModel.fromMap(Map<String, dynamic> map) {
    return LastExpenseModel(
      recieveruid: map['recieveruid'] ?? '',
      amount: map['amount'] ?? '',
      // profileImageUrl: map['profileImageUrl'] ?? '',
      provideruid: map['provideruid'] ?? '',
      about: map['about'] ?? false,
      date: map['date'] ?? 0,
      // phoneNumber: map['phoneNumber'] ?? '',
      // about: map['about'] ?? '',
      // pushToken: map['pushToken'] ?? '',
      // groupId: List<String>.from(map['groupId']),
    );
  }
}
