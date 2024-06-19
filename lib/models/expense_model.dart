class ExpenseModel {
  final String expenseId;
  final String recieveruid;
  final String provideruid;
  final double amount;
  final String about;
  final int date;
  final String expenseType;
  // final bool active;
  // final int lastSeen;
  // final String phoneNumber;
  // final String about;
  // final String pushToken;
  // final List<String> groupId;

  ExpenseModel({
    required this.amount,
    required this.expenseId,
    required this.recieveruid,
    required this.provideruid,
    required this.date,
    required this.about,
    required this.expenseType,
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
      'expenseId': expenseId,
      'provideruid': provideruid,
      'about': about,
      'expenseType': expenseType,
      // 'phoneNumber': phoneNumber,
      // 'about': about,
      // 'pushToken': pushToken,
      'date': date,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      recieveruid: map['recieveruid'] ?? '',
      amount: map['amount'] ?? '',
      expenseId: map['expenseId'] ?? '',
      provideruid: map['provideruid'] ?? '',
      about: map['about'] ?? false,
      date: map['date'] ?? 0,
      expenseType: map['expenseType'] ?? '',
      // about: map['about'] ?? '',
      // pushToken: map['pushToken'] ?? '',
      // groupId: List<String>.from(map['groupId']),
    );
  }
}
