import 'package:flutter/material.dart';
import 'package:quiz_maker/components/drawer.dart';
import 'package:quiz_maker/components/streak_icon.dart';
import 'package:quiz_maker/models/quiz.dart';
import 'package:quiz_maker/services/quizz_service.dart';
import 'package:quiz_maker/views/create_quiz.dart';
import 'package:quiz_maker/widgets/widgets.dart';

import '../components/quiz_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool userLoading = true;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        actions: [
          StreakIconButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 16.0, right: 36.0, bottom: 16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Quizzes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(child: quizList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuiz(),
            ),
          );
        },
      ),
    );
  }

  Widget quizList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<List<Quiz>>(
        stream: QuizService().getQuizzesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Грешка: ${snapshot.error}'));
          } else {
            // Filter quizzes based on search query
            var quizzes = snapshot.data!.where((quiz) {
              return quiz.name.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            if (quizzes.isEmpty) {
              return const Center(child: Text('Няма намерени тестове.'));
            }

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                var quiz = quizzes[index];
                return QuizTile(quiz);
              },
            );
          }
        },
      ),
    );
  }
}

