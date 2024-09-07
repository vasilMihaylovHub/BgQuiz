import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_maker/common/constants.dart';
import 'package:quiz_maker/common/functions.dart';
import 'package:quiz_maker/models/user.dart';
import 'package:quiz_maker/services/points_service.dart';

import '../main.dart';

class UserService {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<void> createUserDocument(ProfileUser user) async {
    await firestoreInstance
        .collection(Constants.usersDbDocument)
        .doc(user.email)
        .set({
      'email': user.email,
      'name': user.name,
      'points': GamePoints.initial,
      'streakDays': [],
      'imageUrl': null
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    final store = await LocalStore.getCurrentUserDetails();
    return await firestoreInstance
        .collection(Constants.usersDbDocument)
        .doc(store.email)
        .get();
  }

  Future<void> updateUserProfile(String name, String? imageUrl) async {
    final store = await LocalStore.getCurrentUserDetails(); //TODO remove
    await firestoreInstance
        .collection(Constants.usersDbDocument)
        .doc(store.email)
        .update({'name': name,
          'imageUrl': imageUrl,
    });
  }

  Future<void> updateUserName(String name) async {
    //TODO: Add userId
    final store = await LocalStore.getCurrentUserDetails(); //TODO remove
    await firestoreInstance
        .collection(Constants.usersDbDocument)
        .doc(store.email)
        .update({'name': name
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestoreInstance.collection(Constants.usersDbDocument).snapshots();
  }

  Future<void> incrementPoints(int gainedPoints) async {
    final store = await LocalStore.getCurrentUserDetails();
    final user = store.email;
    String date = PointsService.getCurrantDate();
    logger.i("Incrementing user points... for: $user, +points: $gainedPoints, day: $date");

    DocumentReference userReference =
    firestoreInstance.collection(Constants.usersDbDocument).doc(user);

    userReference.update({
      'points': FieldValue.increment(gainedPoints),
      'streakDays': FieldValue.arrayUnion([date])
    });
  }
}
