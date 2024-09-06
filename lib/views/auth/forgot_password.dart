import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth_service.dart';
import 'package:quiz_maker/widgets/widgets.dart';

import '../../components/app_bar.dart'; // Assuming you have a blueButton or other reusable widgets

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  AuthService authService = AuthService();
  bool isLoading = false;

  resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      authService.resetPassword(email).then((val){
        if(val) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
                'Инструкции за възстановяване на паролата са изпратени на вашия имейл')),
          );
          Navigator.pop(context);
        }else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
                'Неуспешно изпращане. Моля опитайте отново')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Забравена парола'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Моля въведете вашия имейл за възстановяване на паролата.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (val) {
                  return val!.isEmpty
                      ? "Полето е задължително"
                      : null;
                },
                decoration: const InputDecoration(
                  hintText: "Емайл",
                ),
                onChanged: (val) {
                  email = val;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: resetPassword,
                child: blueButton(context: context, label: "Изпрати"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
