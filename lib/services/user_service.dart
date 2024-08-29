import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_maker/common/constants.dart';
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
}
