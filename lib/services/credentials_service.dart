
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_maker/main.dart';

import '../common/constants.dart';
import '../models/service_account_type.dart';

class CredentialsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> getServiceAccount(ServiceAccountType searchType) async {
    try {
      // Query the service_accounts collection where 'type' matches searchType.name
      QuerySnapshot querySnapshot = await _db
          .collection(Constants.serviceAccountsDbDocument)
          .where('type', isEqualTo: searchType.name)
          .get();

      var document = querySnapshot.docs.first;
      String credentials = document.get('credentials');

      return credentials;
    } catch (e) {
      logger.e('Error getting service account: $e');
      return null;
    }
  }
}
