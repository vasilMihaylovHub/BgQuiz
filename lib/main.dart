import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/common/functions.dart';
import 'package:quiz_maker/theme/dark_mode.dart';
import 'package:quiz_maker/theme/light_mode.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signin.dart';
import 'common/errors/global_error_handler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    await HelperFunctions.getCurrentUserDetails().then((val){
      setState(() {
        _isLoggedIn = val ?? false;
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
