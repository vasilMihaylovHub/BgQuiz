import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/views/signin.dart';

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


  signUp() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      await authService.signUp(name, email, password)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home()));
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
                  "Enter your name" : null;
                },
                decoration: InputDecoration(
                    hintText: "Name"
                ),
                onChanged: (val) {
                  name = val;
                },
              ),

              TextFormField(
                validator: (val) {
                  return val!.isEmpty ?
                  "Enter correct email" : null;
                },
                decoration: InputDecoration(
                    hintText: "Email"
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
                  "Enter correct email" : null;
                },
                decoration: const InputDecoration(
                    hintText: "Password"
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
                child: blueButton(context: context,label: "Sign Up"),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("If you have an account? ",
                    style: TextStyle(fontSize: 16),),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()
                            ));
                      },
                      child: Text("Sign In", style: TextStyle(
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
