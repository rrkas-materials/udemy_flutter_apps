import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {
  static const Color appBarColor = Colors.blue,
      fabBgColor = Colors.blue,
      rowCardColor = Colors.yellowAccent,
      amountTxtColor = Colors.blueGrey,
      amountBgColor = Colors.yellowAccent,
      titleTxtColor = Colors.indigo,
      dateTxtColor = Colors.grey,
      iconColor = Colors.white,
      noTransactionColor = Colors.grey,
      chartBarBgColor = Colors.white,
      addBtnBgColor = Colors.lightGreen,
      addBtnTxtColor = Colors.white,
      deleteIconColor = Colors.red,
      editIconColor = Colors.green;
  static final Color deleteBtnBg = Colors.red.shade50,
      editBtnBg = Colors.green.shade50,
      chartBarCoverColor = Colors.green.shade100,
      chartCardColor = Colors.green.shade50,
      statsActiveMode = Colors.blue,
      statsInactiveMode = Colors.blue.shade100;

  static final List<Color> bars = [
    Colors.red.shade200,
    Colors.red.shade300,
    Colors.red.shade400,
    Colors.red.shade500,
    Colors.red.shade600,
    Colors.red.shade700,
    Colors.red.shade800,
  ];

  static const String appBarFont = 'OpenSans',
      titleFont = 'times',
      amountFont = 'Quicksand',
      dateFont = 'Quicksand';

  static final double btnHeight = 30;

  static String getFormattedDateE(DateTime date) {
    return DateFormat('MMM dd, yyyy | E').format(date).toUpperCase();
  }

  static String getFormattedDateEEEE(DateTime date) {
    return DateFormat('MMM dd, yyyy | EEEE').format(date).toUpperCase();
  }
}
