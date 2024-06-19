import 'package:auhackathon/models/expense_model.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchUsers(String searchTerm) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: searchTerm)
        .get();

    return result.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      return doc.data()!;
    }).toList();
  }

  Future<UserModel?> getUserInfo(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data()!);
      } else {
        // Handle the case where the user document doesn't exist
        return null;
      }
    } catch (error) {
      // Handle errors appropriately
      print('Error fetching user info: $error');
      return null;
    }
  }

  Stream<List<UserModel>> getFriends(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .snapshots()
        .asyncMap((snapshot) async {
      final List<String> friendIds =
          snapshot.docs.map((doc) => doc.id.toString()).toList();

      final List<UserModel> friends = [];

      for (final friendId in friendIds) {
        final UserModel? friend = await getUserInfo(friendId);
        if (friend != null) {
          friends.add(friend);
        }
      }

      return friends;
    });
  }

  Stream<List<ExpenseModel>> getExpenses(String userId,String friendId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .collection('expenses')
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        // Assuming you have an ExpenseModel class to deserialize the data
        return ExpenseModel.fromMap(data);
      }).toList();
    });
  }

  Future<List<ExpenseModel>> getExpensesCalc(String currentUserUid, String friendUid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .doc(currentUserUid)
          .collection('friends')
          .doc(friendUid)
          .collection('expenses')
          .get();

      List<ExpenseModel> expenses = querySnapshot.docs
          .map((doc) => ExpenseModel.fromMap(doc.data()))
          .toList();

      return expenses;
    } catch (e) {
      // Handle error appropriately
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Stream<List<ExpenseModel>> getExpensesStream(String userId, String friendId) {
  //   return FirebaseFirestore.instance
  //       .collection('expenses')
  //       .where('participants', arrayContains: userId)
  //       .where('participants', arrayContains: friendId)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) => ExpenseModel.fromMap(doc.data())).toList();
  //   });
  // }


}
