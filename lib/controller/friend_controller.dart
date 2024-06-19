import 'package:auhackathon/repo/friend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendControllerProvider = Provider((ref) {
  final friendRepository = ref.watch(friendRepositoryProvider);
  return FriendController(
    friendRepository: friendRepository,
    ref: ref,
  );
});

class FriendController {
  final FriendRepository friendRepository;
  final ProviderRef ref;
  FriendController({required this.friendRepository, required this.ref});

  void addFriendToFirebase({
    required String hostUserUid,
    required String friendUserUid,
    // required String username,
    // required String email,
    // // required var profileImage,
    // required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) {
    friendRepository.addFriendToFirebase(
      hostUserUid: hostUserUid,
      friendUserUid: friendUserUid,
      ref: ref,
      context: context,
      mounted: mounted,
    );
  }
}
