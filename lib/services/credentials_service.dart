
import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/constants.dart';
import '../main.dart';
import '../models/service_account_type.dart';

class CredentialsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Object?> getToken(TokenType searchType) async {
     var document = await _db
        .collection(Constants.credentialsDbDocument)
        .doc(searchType.name)
        .get();

    return document.data();
  }

  Future<bool> insertToken(TokenType type, Map<String, dynamic> token) async {

    try {
      await _db
          .collection(Constants.credentialsDbDocument)
          .doc(type.name)
          .set(token);
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }
}
