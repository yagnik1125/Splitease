import 'package:auhackathon/models/expense_model.dart';
import 'package:auhackathon/models/group_expense_model.dart';
import 'package:auhackathon/models/group_model.dart';
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

  Stream<List<ExpenseModel>> getExpenses(String userId, String friendId) {
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

  Future<void> deleteExpense(String userId, String friendId, String expenseId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .collection('expenses')
          .doc(expenseId)
          .delete();

      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  Future<List<ExpenseModel>> getExpensesCalc(
      String currentUserUid, String friendUid) async {
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


  Future<List<GroupExpenseModel>> getGroupExpensesForCalc(
      String groupId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('groups')
          .doc(groupId)
          // .collection('friends')
          // .doc(friendUid)
          .collection('expenses')
          .get();

      List<GroupExpenseModel> expenses = querySnapshot.docs
          .map((doc) => GroupExpenseModel.fromMap(doc.data()))
          .toList();

      return expenses;
    } catch (e) {
      // Handle error appropriately
      print('Error fetching group expenses: $e');
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

  Stream<List<GroupModel>> getGroups(String userId) {
    Stream<List<GroupModel>> allGroups =
        _firestore.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data()))
          .toList();
    });
    // allGroups.listen((groupList) {
    //   print("Groups List: $groupList");
    //   for (var group in groupList) {
    //     print("Group: ${group.groupname}, Members: ${group.members.length}");
    //   }
    // });

    Stream<List<GroupModel>> userGroups = allGroups.map((groupList) {
      return groupList.where((group) {
        return group.members.any((member) => member.uid == userId);
      }).toList();
    });

    // userGroups.listen((groupList) {
    //   print("Filtered Groups List: $groupList");
    //   for (var group in groupList) {
    //     print("Group: ${group.groupname}, Members: ${group.members.length}");
    //   }
    // });

    return userGroups;
  }

  Future<GroupModel?> getGroupById(String groupId) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('groups').doc(groupId).get();

    if (docSnapshot.exists) {
      return GroupModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> updateGroup(GroupModel group) async {
    await _firestore.collection('groups').doc(group.groupid).update(group.toMap());
  }

  // Add a new expense to a group's "expenses" collection
  Future<void> addExpenseToGroup(GroupExpenseModel expense) async {
    try {
      await _firestore
          .collection('groups')
          .doc(expense.groupid)
          .collection('expenses')
          .doc(expense.expenseId)
          .set(expense.toMap());
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  // Retrieve all expenses for a group
  Stream<List<GroupExpenseModel>> getExpensesForGroup(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('expenses')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupExpenseModel.fromMap(doc.data()))
            .toList());
  }

  // Retrieve a specific expense by its ID for a group
  Future<GroupExpenseModel?> getExpenseById(String groupId, String expenseId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('expenses')
          .doc(expenseId)
          .get();
      if (doc.exists) {
        return GroupExpenseModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving expense: $e');
      return null;
    }
  }

  Future<void> deleteGroupExpense(String groupId, String expenseId) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          // .collection('friends')
          // .doc(friendId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }
}
