import 'package:auhackathon/repo/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseControllerProvider = Provider((ref) {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  return ExpenseController(
    expenseRepository: expenseRepository,
    ref: ref,
  );
});

class ExpenseController {
  final ExponseRepository expenseRepository;
  final ProviderRef ref;
  ExpenseController({required this.expenseRepository, required this.ref});

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
    // required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) {
    expenseRepository.addExpenseToFirebase(
        expenseType: expenseType,
        date: date,
        amount: amount,
        about: about,
        providerUid: providerUid,
        recieverUid: recieverUid,
        expenseId: expenseId,
        ref: ref,
        context: context,
        mounted: mounted);
  }

  void addGroupExpenseToFirebase({
    required String groupId,
    required DateTime date,
    required double amount,
    required String about,
    required String providerUid,
    required String recieverUid,
    required String expenseId,
    // required String username,
    // required String email,
    // // required var profileImage,
    // required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) {
    expenseRepository.addGroupExpenseToFirebase(
        groupId: groupId,
        date: date,
        amount: amount,
        about: about,
        providerUid: providerUid,
        recieverUid: recieverUid,
        expenseId: expenseId,
        ref: ref,
        context: context,
        mounted: mounted);
  }
}
