import 'package:flutter/foundation.dart';
import 'package:googleapis/logging/v2.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';

const serviceAccountCredentials = {
  "type": "service_account",
  "project_id": "bgquiz-ef282",
  "private_key_id": "a726ad96011aa031f421159778df136c45bc055a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDC3B2yBPyZiGnv\nZGLnO8ieGtyXTMNMrazIGcGAlX/7OPf8P5HfHKGT5M6cXWB/1k9yFrhFd3i4Mx+C\n+mjf7HKS2fQnlC8G064HSRzzeicv3o12fyMbbXx6yIkewZ264Cbn/XAZDxbNqOTs\nPFCCDAK673sUUs3d9cmIYeQcXs5VOZ075V1GeSWgvqS/GDh6Ismx9NHc+EPTTMpF\nEgtyGU+TZ0ua6G/Himnz4MiUMO548FidkTdW1JYSmyGxmJ1NN8qmQUb/l8gDYGu/\nr4YPjx7xu5NjjsjYhk86JwCNLHzbJuq+JrB6s6edheEw8MVlNmAWkkGxnE8cQ8QL\nw+/NxRL1AgMBAAECggEAAb7e6883tKfREVaAvHkBbvv+v/i0PfisKhXxS/dq4s81\n2gcfmcobhBMqkBTLzLS9yohWs/dy9ITX/H0WSHOQLpzix4BbPYs37w6XGijMGJ+/\n7uhv1+46bwVOh/8zUWhk1J7N0dbOfSI8Sc/zgjTWQlGupvX4JZlJ2THodZSM8j5o\nfBMdBJysggIaZgZ5mG78SqKFZqtQAQTScKDPefSvh58s2kpbmYLdWWM8hrT9+9Fy\nxpPZYWBuFfTN2Ua8V/OsswClgCOgcX/HbvXDGUGak8JrM2SPlvvvwWzv1eEceghT\ndw8VkTs6KEJRUSVbtig8I1E1T+AHRY1vAwxftSWIaQKBgQD0pkM3C/5NrIu66xdb\n9SrLkUir6tt5KewVVwad8jmgPF3Ya4S1ScYcRFHLEFM3vtQ1QZynPTEPDFt9Fd3Q\nPPRrKIJ6sDadstZakZ+u1G72zT9SIvvhQAaKe+Jt4YRM7WbVEuOrQvCRjrp6Zebq\ntcU1SW9WQCRNkHI51tuN7wo82QKBgQDL5n6iWKfUlkHBuAlnSo4A/WH233hZZbMs\nD7Y/5wsGuyEiRHOp10UG6zslZ1fGiray7wnH+215U7fOtY6vXWyWlGam7SloM49Y\npoyplNcTpRHKZZBe3R0K7rMxNUDQoTxF7ONs0EdoAZv7jv0EwF4z0KnEtSp2meIg\no7DOfoolfQKBgDW6of5f4uy6HUHiyZGHiWuFr7kZ7jNw8olJQInFncREHbQfANkz\np4+jrXb0UeJnRYGgtD/CX5jXdOxGth06lc9G6Uj6lDQUB6GCY9hojSokr2hhiIHS\npt0ZEgRhx8WBSdk3ucpt/BlriCbDZHBdlT77rrj5gz+Jnpx3RGaqfcwZAoGBAI7z\nk1bIpymhCosBNv6Gw5YoDxWgyOSMK5i5j0Gv/wgCDBHVQe4SMZ/PLZFkqaJVwA8l\nDYt6V98W9afjnByQeD/93RYs8bnPZDF32uhNpJhuQ1HN8PDBPspaXaEjP8TFNdek\nZDH2uAlQD4bHUdaR87mKEmwJw7KQ4nuVp7CuALaVAoGAQB/PTLSeYrmeUVVGW3U3\nznBWDKJtefvLEL/6vsLy7CTle7cTCCEZheixoO3PiKrAFTtcPJ1j09vzHdfAArHc\nBEUU9mxxDJmPqytGPe6cjQU91Yjx+f6ToB+/2HXuVzZOiiy3fTXH0fcn6R0As6qB\n870IrEWYBe3Ws5NdrAalnmw=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-logger@bgquiz-ef282.iam.gserviceaccount.com",
  "client_id": "106393113295542672768",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-logger%40bgquiz-ef282.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};
const _projectId = 'bgquiz-ef282';

class GoogleCloudLoggingService {
  late LoggingApi _loggingApi; // Instance variable for Cloud Logging API
  bool _isSetup = false; // Indicator to check if the API setup is complete

  // Method to set up the Cloud Logging API
  Future<void> setupLoggingApi() async {
    if (_isSetup) return;

    try {


      final credentials = ServiceAccountCredentials.fromJson(
        serviceAccountCredentials,
      );

      // Authenticate using ServiceAccountCredentials and obtain an AutoRefreshingAuthClient authorized client
      final authClient = await clientViaServiceAccount(
        credentials,
        [LoggingApi.loggingWriteScope],
      );

      // Initialize the Logging API with the authorized client
      _loggingApi = LoggingApi(authClient);

      // Mark the Logging API setup as complete
      _isSetup = true;
      debugPrint('Cloud Logging API setup for $_projectId');
    } catch (error) {
      debugPrint('Error setting up Cloud Logging API $error');
    }
  }

  void writeLog({required Level level, required String message, required String? userMail}) {
    if (!_isSetup) {
      // If Logging API is not setup, return
      debugPrint('Cloud Logging API is not setup');
      return;
    }

    // Define environment and log name
    const env = 'dev';
    const logName = 'projects/$_projectId/logs/$env'; // It should in the format projects/[PROJECT_ID]/logs/[LOG_ID]

    // Create a monitored resource
    final resource = MonitoredResource()..type = 'global'; // A global resource type is used for logs that are not associated with a specific resource
    final timestamp = DateTime.now().toUtc().toIso8601String();

    // Map log levels to severity levels
    final severityFromLevel = switch (level) {
      Level.fatal => 'CRITICAL',
      Level.error => 'ERROR',
      Level.warning => 'WARNING',
      Level.info => 'INFO',
      Level.debug => 'DEBUG',
      _ => 'NOTICE',
    };

    // Create a log entry
    final logEntry = LogEntry()
      ..logName = logName
      ..jsonPayload = {'message': message}
      ..resource = resource
      ..severity = severityFromLevel
      ..labels = {
        'project_id': _projectId,
        'level': level.name.toUpperCase(),
        'environment': env,
        'user_mail': userMail ?? 'unknown-user',
        'timestamp': timestamp,
      };

    // Create a write log entries request
    final request = WriteLogEntriesRequest()..entries = [logEntry];

    // Write the log entry using the Logging API and handle errors
    _loggingApi.entries.write(request).catchError((error) {
      debugPrint('Error writing log entry $error');
      return WriteLogEntriesResponse();
    });
  }
}