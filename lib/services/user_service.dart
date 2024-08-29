import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_maker/common/constants.dart';
import 'package:quiz_maker/common/functions.dart';
import 'package:quiz_maker/models/user.dart';

class UserService {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<void> createUserDocument(ProfileUser user) async {
    await firestoreInstance
        .collection(Constants.usersDbDocument)
        .doc(user.email)
        .set({
      'email': user.email,
      'name': user.name,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    final store = await LocalStore.getCurrentUserDetails();
    return await firestoreInstance
        .collection(Constants.usersDbDocument)
        .doc(store.email)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestoreInstance.collection(Constants.usersDbDocument).snapshots();
  }
}
