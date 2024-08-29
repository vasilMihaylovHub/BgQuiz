import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth_service.dart';
import 'package:quiz_maker/services/user_service.dart';
import 'package:quiz_maker/views/signin.dart';

import '../common/functions.dart';
import '../models/user.dart';
import '../widgets/widgets.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  late String name, email, password;
  late ProfileUser profileUser;
  AuthService authService = AuthService();
  UserService userService = UserService();
  bool isLoading = false;


  signUp() {
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
        profileUser = ProfileUser(email: email, name: name, password: password);
      });
      authService.signUp(email, password)
          .then((authUser) {
            if(authUser != null) {
              userService.createUserDocument(profileUser);

              HelperFunctions.saveCurrentUser(isLoggedIn: true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home()));
            }
      });

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
      ),
      body: isLoading ?
      Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                validator: (val) {
                  return val!.isEmpty ?
                  "Полето е задължително" : null;
                },
                decoration: InputDecoration(
                    hintText: "Име"
                ),
                onChanged: (val) {
                  name = val;
                },
              ),

              TextFormField(
                validator: (val) {
                  return val!.isEmpty ?
                  "Полето е задължително" : null;
                },
                decoration: InputDecoration(
                    hintText: "Емайл"
                ),
                onChanged: (val) {
                  email = val;
                },
              ),
              TextFormField(
                obscureText: true,
                validator: (val) {
                  return val!.isEmpty ?
                  "Полето е задължително" : null;
                },
                decoration: const InputDecoration(
                    hintText: "Парола"
                ),
                onChanged: (val) {
                  password = val;
                },
              ),
              TextFormField(
                obscureText: true,
                validator: (val) {
                  return val != password ?
                  "Паролите не съвпадат" : null;
                },
                decoration: const InputDecoration(
                    hintText: "Потвърждение на паролата"
                ),
              ),
              SizedBox(height: 24,),
              GestureDetector(
                onTap: () {
                  signUp();
                },
                child: blueButton(context: context,label: "Регистрирай"),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Вече си регистриран? ",
                    style: TextStyle(fontSize: 16),),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()
                            ));
                      },
                      child: Text("Влез", style: TextStyle(
                          fontSize: 16, decoration: TextDecoration.underline)))
                ],
              ),
              SizedBox(height: 80,)
            ],
          ),
        ),
      ),
    );
  }
}
