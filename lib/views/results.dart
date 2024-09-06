import 'package:flutter/material.dart';
import 'package:quiz_maker/models/result_model.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class Results extends StatefulWidget {
  final ResultModel result;

  const Results({super.key, required this.result});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("${widget.result.correct}/${widget.result.total}", style: TextStyle(fontSize: 25),),
            SizedBox(height: 8),
            Text("Отговорени вярно въпроси: ${widget.result.correct} "
                "и неправилно: ${widget.result.incorrect + widget.result.notAttempted}.", style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center),
              SizedBox(height: 14),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: blueButton(context: context,
                      label: "Начален екран",
                      buttonWidth:  MediaQuery.of(context).size.width/2 - 48)
              )
          ],),
        ),
      ),
    );
  }
}

