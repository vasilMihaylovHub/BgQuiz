import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth_service.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signup.dart';
import 'package:quiz_maker/widgets/widgets.dart';

import '../common/functions.dart';

  class SignIn extends StatefulWidget {
    const SignIn({super.key});

    @override
    State<SignIn> createState() => _SignInState();
  }

  class _SignInState extends State<SignIn> {

    final _formKey = GlobalKey<FormState>();
    late String email, password;
    AuthService authService= AuthService();

    bool isLoading = false;

    signIn() async {
      if(_formKey.currentState!.validate()){
        setState(() {
          isLoading = true;
        });
        await authService.signIn(email, password)
        .then((user) {
          if(user != null) {
            HelperFunctions.saveCurrentUser(isLoggedIn: true);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Home()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Неуспешно влизане. Моля опитайте отново'))
            );
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
        const Center(
          child: CircularProgressIndicator(),
        ) : Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                TextFormField(
                  validator: (val){
                    return val!.isEmpty ?
                    "Полето е задължително" : null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Емайл"
                  ),
                  onChanged: (val){
                    email = val;
                  },
                ),
                SizedBox(height: 6,),
                TextFormField(
                  obscureText: true,
                  validator: (val){
                    return val!.isEmpty ?
                    "Полето е задължително" : null;
                  },
                  decoration: InputDecoration(
                      hintText: "Парола"
                  ),
                  onChanged: (val){
                    password = val;
                  },
                ),
                SizedBox(height: 24,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: blueButton(context: context, label: "Влез"),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Нямаш регистрация? ", style: TextStyle(fontSize: 16),),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp())
                          );
                        },
                        child: Text("Регистрация", style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)
                        )
                    )
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
    