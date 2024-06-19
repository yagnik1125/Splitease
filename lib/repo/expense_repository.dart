import 'package:auhackathon/models/expense_model.dart';
import 'package:auhackathon/widgets/show_alert_dialog.dart';
import 'package:auhackathon/widgets/show_loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseRepositoryProvider = Provider(
  (ref) {
    return ExponseRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      realtime: FirebaseDatabase.instance,
    );
  },
);

class ExponseRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase realtime;

  ExponseRepository({
    required this.auth,
    required this.firestore,
    required this.realtime,
  });

  void addExpenseToFirebase({
    required String expenseType,
    required DateTime date,
    required double amount,
    required String about,
    required String providerUid,
    required String recieverUid,
    required String expenseId,
    // required String username,
    // required String email,
    // // required var profileImage,
    required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      showLoadingDialog(context: context, message: 'Adding Expense..');
      await firestore
          .collection('users')
          .doc(providerUid)
          .collection('friends')
          .doc(recieverUid)
          .collection('expenses')
          .doc(expenseId)
          .set(ExpenseModel(
            about: about,
            amount: amount,
            date: date.microsecondsSinceEpoch,
            expenseType: expenseType,
            expenseId: expenseId,
            recieveruid: recieverUid,
            provideruid: providerUid,
          ).toMap());
      await firestore
          .collection('users')
          .doc(recieverUid)
          .collection('friends')
          .doc(providerUid)
          .collection('expenses')
          .doc(expenseId)
          .set(ExpenseModel(
            about: about,
            amount: amount,
            date: date.microsecondsSinceEpoch,
            expenseType: expenseType,
            expenseId: expenseId,
            recieveruid: recieverUid,
            provideruid: providerUid,
          ).toMap());
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense Added')),
      );
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }
  }
}
