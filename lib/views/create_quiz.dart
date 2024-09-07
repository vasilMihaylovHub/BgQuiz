import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File handling
import 'package:quiz_maker/common/constants.dart';
import 'package:quiz_maker/models/quiz.dart';
import 'package:quiz_maker/services/asset_service.dart';
import 'package:quiz_maker/services/quizz_service.dart';
import 'package:quiz_maker/services/auth_service.dart';

import '../components/app_bar.dart';
import '../services/user_service.dart';
import '../widgets/widgets.dart';
import 'add_question.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String quizTitle, quizDesc;
  File? quizImgFile;
  bool isLoading = false;
  QuizService databaseService = QuizService();
  AuthService authService = AuthService();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        quizImgFile = File(pickedFile.path);
      });
    }
  }


  createQuiz() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      final currentUser = await authService.getCurrentUser();

      // Here we upload the image file and get the URL
      final imageUrl = await AssetService().uploadImage(quizImgFile!);

      final newQuiz = Quiz(
          name: quizTitle,
          imgUrl: imageUrl,
          description: quizDesc,
          creatorEmail: currentUser?.email ?? Constants.defaultMail,
          likes: []
      );
      await UserService().incrementPoints(0); // to activate streak

      databaseService.createQuiz(newQuiz).then((creationSuccess) {
        setState(() {
          isLoading = false;
        });
        if (creationSuccess) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddQuestion(quizId: newQuiz.id)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Неуспешно създаван на тест. Моля опитайте отново')));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Създаване на тест'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: quizImgFile != null
                      ? Image.file(
                    quizImgFile!,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.add_a_photo, size: 50),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(hintText: "Заглавие"),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Описание"),
                onChanged: (val) {
                  quizDesc = val;
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: blueButton(context: context, label: "Създай"),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}