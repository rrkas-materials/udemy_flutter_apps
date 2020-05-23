import 'package:flutter/material.dart';

import './answer.dart';
import './question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> ques;
  final int questionIndex;
  final Function answerQuestion;

  Quiz({
    @required this.answerQuestion,
    @required this.ques,
    @required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Question(
          ques[questionIndex]['questionText'],
        ),
        ...(ques[questionIndex]['answers'] as List<Map<String, Object>>).map((answer) {
          return Answer(()=>answerQuestion(answer['score']), answer['text']);
        }).toList(),
      ],
    );
  }
}
