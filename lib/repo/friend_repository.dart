import 'package:auhackathon/models/last_expense_model.dart';
import 'package:auhackathon/widgets/show_alert_dialog.dart';
import 'package:auhackathon/widgets/show_loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendRepositoryProvider = Provider(
  (ref) {
    return FriendRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      realtime: FirebaseDatabase.instance,
    );
  },
);

class FriendRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase realtime;

  FriendRepository({
    required this.auth,
    required this.firestore,
    required this.realtime,
  });

  void addFriendToFirebase({
    required String hostUserUid,
    required String friendUserUid,
    // required String username,
    // required String email,
    // // required var profileImage,
    required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      showLoadingDialog(context: context, message: 'Adding Friend');
      await firestore
          .collection('users')
          .doc(hostUserUid)
          .collection('friends')
          .doc(friendUserUid)
          .set(LastExpenseModel(
                  recieveruid: friendUserUid,
                  provideruid: hostUserUid,
                  about: "",
                  amount: 0,
                  date: DateTime.now())
              .toMap());
      await firestore
          .collection('users')
          .doc(friendUserUid)
          .collection('friends')
          .doc(hostUserUid)
          .set(LastExpenseModel(
                  recieveruid: hostUserUid,
                  provideruid: friendUserUid,
                  about: "",
                  amount: 0,
                  date: DateTime.now())
              .toMap());
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend Added')),
      );
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }
  }
}
