import 'package:flutter/material.dart';
import 'package:quiz_maker/common/constants.dart';
import 'package:quiz_maker/models/result_model.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class Results extends StatefulWidget {
  final ResultModel result;

  const Results({super.key, required this.result});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late double successRate;
  late int points;
  late int currPoints = 0;// Get them from the DB

  @override
  void initState() {
    super.initState();
    calculateSuccessRateAndPoints();
  }

  void calculateSuccessRateAndPoints() {
    successRate = widget.result.correct / widget.result.total * 100;

    if (successRate == 100) {
      points = GamePoints.solvedQuiz100;
    } else if (successRate >= 80) {
      points = GamePoints.solvedQuiz80;
    } else {
      points = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.result.correct}/${widget.result.total}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 8),
              Text(
                "Отговорени вярно въпроси: ${widget.result.correct} "
                    "и неправилно: ${widget.result.incorrect + widget.result.notAttempted}.",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              Text(
                "Процент на успеваемост: ${successRate.toStringAsFixed(2)}%",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              Text(
                "Спечелени точки: $points, натрупани: $currPoints",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: blueButton(
                  context: context,
                  label: "Начален екран",
                  buttonWidth: MediaQuery.of(context).size.width / 2 - 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
