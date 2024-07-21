class GroupExpenseModel {
  final String expenseId;
  final String groupid;
  final String provideruid;
  final double amount;
  final String about;
  final int date;
  final String receiverUid; // new field for the receiver's UID

  GroupExpenseModel({
    required this.expenseId,
    required this.groupid,
    required this.provideruid,
    required this.amount,
    required this.about,
    required this.date,
    required this.receiverUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'expenseId': expenseId,
      'groupid': groupid,
      'provideruid': provideruid,
      'amount': amount,
      'about': about,
      'date': date,
      'receiverUid': receiverUid,
    };
  }

  factory GroupExpenseModel.fromMap(Map<String, dynamic> map) {
    return GroupExpenseModel(
      expenseId: map['expenseId'] ?? '',
      groupid: map['groupid'] ?? '',
      provideruid: map['provideruid'] ?? '',
      amount: map['amount'] ?? 0.0,
      about: map['about'] ?? '',
      date: map['date'] ?? 0,
      receiverUid: map['receiverUid'] ?? '',
    );
  }
}
