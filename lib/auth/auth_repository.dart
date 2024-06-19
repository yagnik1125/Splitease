// import 'package:auhackathon/auth/firebase_storage_repository.dart';
import 'package:auhackathon/auth/firebase_storage_repository.dart';
import 'package:auhackathon/auth/login.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:auhackathon/widgets/show_alert_dialog.dart';
import 'package:auhackathon/widgets/show_loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) {
    return AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      realtime: FirebaseDatabase.instance,
    );
  },
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase realtime;

  AuthRepository({
    required this.auth,
    required this.firestore,
    required this.realtime,
  });

//------------------original getUserPresenceStatus code start-------------------------------
  // Stream<UserModel> getUserPresenceStatus({required String uid}) {
  //   return firestore
  //       .collection('users')
  //       .doc(uid)
  //       .snapshots()
  //       .map((event) => UserModel.fromMap(event.data()!));
  // }
//------------------original getUserPresenceStatus code end-------------------------------

//-------------------------original code start-------------------------------------------
  // void updateUserPresence() {
  //   Map<String, dynamic> online = {
  //     'active': true,
  //     'lastSeen': DateTime.now().millisecondsSinceEpoch,
  //   };
  //   Map<String, dynamic> offline = {
  //     'active': false,
  //     'lastSeen': DateTime.now().millisecondsSinceEpoch,
  //   };
  //   final connectedRef = realtime.ref('.info/connected');
  //   connectedRef.onValue.listen(
  //     (event) async {
  //       final isConnected = event.snapshot.value as bool? ?? false;
  //       if (isConnected) {
  //         await realtime.ref().child(auth.currentUser!.uid).update(online);
  //       } else {
  //         realtime
  //             .ref()
  //             .child(auth.currentUser!.uid)
  //             .onDisconnect()
  //             .update(offline);
  //       }
  //     },
  //   );
  // }
//-------------------------original code end-------------------------------------------

//---------------------------------chat gpt start----------------------------------------------------------
  // void updateUserPresence() {
  //   Map<String, dynamic> onlineStatus = {
  //     'status': 'online',
  //     'lastSeen': DateTime.now().millisecondsSinceEpoch,
  //   };
  //   Map<String, dynamic> offlineStatus = {
  //     'status': 'offline',
  //     'lastSeen': DateTime.now().millisecondsSinceEpoch,
  //   };
  //   final connectedRef = realtime.ref('.info/connected');
  //   final usersRef = realtime.ref('users'); // Reference to the "users" path
  //   connectedRef.onValue.listen(
  //     (event) async {
  //       final isConnected = event.snapshot.value as bool? ?? false;
  //       if (isConnected) {
  //         // User is online
  //         await usersRef.child(auth.currentUser!.uid).update(onlineStatus);
  //         // // Also update the presence on Firestore
  //         // await firestore
  //         //     .collection('users')
  //         //     .doc(auth.currentUser!.uid)
  //         //     .update(onlineStatus);
  //       } else {
  //         // User is offline
  //         await usersRef
  //             .child(auth.currentUser!.uid)
  //             .update(offlineStatus)
  //             .then((_) {
  //           // Set up onDisconnect to update status when the client disconnects
  //           usersRef
  //               .child(auth.currentUser!.uid)
  //               .onDisconnect()
  //               .update(offlineStatus);
  //         });

  //         // // Also update the presence on Firestore when disconnected
  //         // await firestore
  //         //     .collection('users')
  //         //     .doc(auth.currentUser!.uid)
  //         //     .update(offlineStatus);
  //       }
  //     },
  //   );
  // }
//---------------------------------chat gpt end----------------------------------------------------------

//---------------------------rajpurohit start------------------------------------------------------------
  // Future<void> updateActiveStatusInFirestore(bool isOnline) async {
  //   await firestore.collection('users').doc(auth.currentUser!.uid).update({
  //     'active': isOnline,
  //     'lastSeen': DateTime.now().millisecondsSinceEpoch
  //   });
  // }
//---------------------------rajpurohit end------------------------------------------------------------

  Future<UserModel?> getCurrentUserInfo() async {
    UserModel? user;
    final userInfo =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userInfo.data() == null) return user;
    user = UserModel.fromMap(userInfo.data()!);
    return user;
  }

  void saveUserInfoToFirestore({
    required String username,
    required String email,
    required var profileImage,
    required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      showLoadingDialog(context: context, message: 'Saving user info...');
      String uid = auth.currentUser!.uid;
      String profileImageUrl = profileImage is String ? profileImage : '';

      if (profileImage != null && profileImage is! String) {
        profileImageUrl = await ref
            .read(firebaseStorageRepositoryProvider)
            .storeFileToFirebase('profileImage/$uid', profileImage);
      }

      // String profileImageUrl = '';
      // if (profileImage != null) {
      //   profileImageUrl = await ref
      //       .read(firebaseStorageRepositoryProvider)
      //       .storeFileToFirebase('profileImage/$uid', profileImage);
      // }
      UserModel user = UserModel(
        username: username,
        uid: uid,
        profileImageUrl: profileImageUrl,
        email: email,
        groupId: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const MyHomePage(title: "Home Page"),
      //   ),
      // );
      // Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }
  }

  // void verifySmsCode({
  //   required BuildContext context,
  //   required String smsCodeId,
  //   required String smsCode,
  //   required bool mounted,
  // }) async {
  //   try {
  //     showLoadingDialog(context: context, message: 'Verifying code...');
  //     final credential = PhoneAuthProvider.credential(
  //       verificationId: smsCodeId,
  //       smsCode: smsCode,
  //     );
  //     await auth.signInWithCredential(credential);
  //     UserModel? user = await getCurrentUserInfo();
  //     if (!mounted) return;
  //     Navigator.of(context).pushNamedAndRemoveUntil(
  //       Routes.userInfo,
  //       (route) => false,
  //       arguments: user?.profileImageUrl,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.pop(context);
  //     showAlertDialog(context: context, message: e.toString());
  //   }
  // }

  // void sendSmsCode({
  //   required BuildContext context,
  //   required String phoneNumber,
  // }) async {
  //   try {
  //     showLoadingDialog(
  //       context: context,
  //       message: "Sending a verification code to $phoneNumber",
  //     );
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (e) {
  //         showAlertDialog(context: context, message: e.toString());
  //       },
  //       codeSent: (smsCodeId, resendSmsCodeId) {
  //         Navigator.of(context).pushNamedAndRemoveUntil(
  //           // context,
  //           Routes.verification,
  //           (route) => false,
  //           arguments: {
  //             'phoneNumber': phoneNumber,
  //             'smsCodeId': smsCodeId,
  //           },
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (String smsCodeId) {},
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.pop(context);
  //     showAlertDialog(context: context, message: e.toString());
  //     print(e.toString());
  //   }
  // }
}
