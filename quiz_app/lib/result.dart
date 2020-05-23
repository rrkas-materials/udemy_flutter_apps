import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int score;
  final Function reset;

  Result(this.score, this.reset);

  String get resultPhrase{
    String text;
    if(score<=8) text = 'you are awesome and innoscent';
    else if (score<=12) text = 'pretty likeable';
    else if (score<=16) text = 'you are strange';
    else text = 'you are so bad';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            resultPhrase,
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            color: Colors.grey,
            textColor: Colors.white,
            child: Text('Restart'),
            onPressed: reset,
          ),
        ],
      ),
    );
  }
}
