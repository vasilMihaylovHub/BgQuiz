import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quiz_maker/common/functions.dart';
import 'package:quiz_maker/services/monitoring/custom_log_filter.dart';
import 'package:quiz_maker/services/monitoring/google_cloud_logging_service.dart';
import 'package:quiz_maker/theme/dark_mode.dart';
import 'package:quiz_maker/theme/light_mode.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signin.dart';
import 'common/errors/global_error_handler.dart';
import 'firebase_options.dart';

final logger = Logger(filter: CustomLogFilter());
final googleCloudLoggingService = GoogleCloudLoggingService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await googleCloudLoggingService.setupLoggingApi();
  Logger.addOutputListener((event) async {
    final user = await LocalStore.getCurrentUserDetails();
    googleCloudLoggingService.writeLog(
      level: event.level,
      message: event.lines.join('\n'),
      userMail: user.email,
    );
    debugPrint('App will log output to Cloud Logging');
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.i('App started');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    checkUserLoggedInStatus();
    super.initState();
  }

  checkUserLoggedInStatus() async {
    await LocalStore.getCurrentUserDetails().then((store){
      setState(() {
        _isLoggedIn = store.isLogged ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: GlobalErrorHandler(
          child: _isLoggedIn ? const Home() : const SignIn()
      ),
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
    );  }
}
