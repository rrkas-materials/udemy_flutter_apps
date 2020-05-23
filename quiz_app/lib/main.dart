import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _ques = const [
    {
      'questionText': 'what\'s your favorite color?',
      'answers': [
        {
          'text': 'Black',
          'score': 10,
        },
        {
          'text': 'Red',
          'score': 5,
        },
        {
          'text': 'Green',
          'score': 3,
        },
        {
          'text': 'White',
          'score': 1,
        },
      ],
    },
    {
      'questionText': 'what\'s your favorite animal?',
      'answers': [
        {
          'text': 'Rabbit',
          'score': 3,
        },
        {
          'text': 'Snake',
          'score': 11,
        },
        {
          'text': 'Elephant',
          'score': 5,
        },
        {
          'text': 'Lion',
          'score': 9,
        },
      ],
    },
    {
      'questionText': 'what\'s your favorite language?',
      'answers': [
        {
          'text': 'C',
          'score': 1,
        },
        {
          'text': 'C++',
          'score': 2,
        },
        {
          'text': 'Java',
          'score': 3,
        },
        {
          'text': 'Python',
          'score': 4,
        },
      ],
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz(){
    setState(() {
      _totalScore=0;
      _questionIndex=0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex++;
    });
    print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Personality Quiz'),
        ),
        body: _questionIndex < _ques.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                ques: _ques,
                questionIndex: _questionIndex,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
