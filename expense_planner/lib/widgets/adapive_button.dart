import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../util.dart';

class AdaptiveButton extends StatelessWidget {
  final Function onPressed;

  AdaptiveButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: const Text(
              'Choose Date',
            ),
            onPressed: onPressed,
          )
        : RaisedButton(
            color: Colors.white,
            textColor: Util.addBtnBgColor,
            child: const Text(
              'Choose Date',
            ),
            onPressed: onPressed,
          );
  }
}
