import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/views/signin.dart';

import '../common/functions.dart';
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
  AuthService authService = AuthService();
  bool isLoading = false;


  signUp() {
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      authService.signUp(name, email, password)
          .then((user) {
            if(user != null) {
              HelperFunctions.saveCurrentUser(isLoggedIn: true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home()));
            }
      });/*.catchError(onError)*/

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
              SizedBox(height: 6,),
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
