import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signup.dart';
import 'package:quiz_maker/widgets/widgets.dart';

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
                  validator: (val){
                    return val!.isEmpty ?
                    "Enter correct email" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email"
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
                    "Enter password" : null;
                  },
                  decoration: InputDecoration(
                      hintText: "Password"
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
                  child: Container(
                    // height: 50,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Sign in",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(fontSize: 16),),
                    GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignUp())
                          );
                        },
                        child: Text("Sign up", style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)
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
    