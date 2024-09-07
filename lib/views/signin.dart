import 'package:flutter/material.dart';
import 'package:quiz_maker/components/signin_providers.dart';
import 'package:quiz_maker/components/text_field.dart';
import 'package:quiz_maker/main.dart';
import 'package:quiz_maker/services/auth_service.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signup.dart';
import 'package:quiz_maker/widgets/widgets.dart';

import '../common/functions.dart';
import 'auth/forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  AuthService authService = AuthService();

  bool isLoading = false;

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService.signIn(email, password).then((user) {
        logger.i("signIn response: $user");
        if (user != null) {
          LocalStore.saveCurrentUser(isLoggedIn: true, email: email);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Неуспешно влизане. Моля опитайте отново')));
        }
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appBarLogo(context),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person,
                        size: 80,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary), // change with logo of the game
                    const SizedBox(height: 45),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Полето е задължително" : null;
                      },
                      decoration: const InputDecoration(hintText: "Емайл"),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val!.isEmpty ? "Полето е задължително" : null;
                      },
                      decoration: InputDecoration(hintText: "Парола"),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: blueButton(context: context, label: "Влез"),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(right: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: const MyTextField(
                                text: 'Забравена парола',
                                fontWeight: FontWeight.bold,
                                textDecoration: TextDecoration.underline),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: const MyTextField(
                                text: 'Регистрация',
                                fontWeight: FontWeight.bold,
                                textDecoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SignInProviders(onProviderTab: (provider) {
                      authService.signInWithGoogle();
                    })
                  ],
                ),
              ),
            ),
    );
  }
}
