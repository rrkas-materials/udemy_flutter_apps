import 'dart:math';

import 'package:expenseplanner/widgets/item_delete_btn.dart';
import 'package:expenseplanner/widgets/item_edit_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../util.dart';

class ListItem extends StatefulWidget {
  const ListItem(
      {Key key,
      @required this.e,
//    @required this.mq,
      @required this.deleteTransaction,
      @required this.editTransaction,
      @required this.maxWidth})
      : super(key: key);

  final Transaction e;

//  final MediaQueryData mq;
  final Function deleteTransaction, editTransaction; //, editTransaction;
  final double maxWidth;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  Color bgColor;

  @override
  void initState() {
    final colorList = [
      Colors.yellow.shade100,
      Colors.white,
      Colors.blue.shade50,
      Colors.green.shade50
    ];
    bgColor = colorList[Random().nextInt(colorList.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Util.rowCardColor,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(width: 1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  child: Text(
                    'Rs. \n' + widget.e.amount.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: Util.amountFont,
                        fontWeight: FontWeight.bold,
                        color: Util.amountTxtColor),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.e.title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: Util.titleFont,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Util.titleTxtColor,
                    ),
                  ),
                  Text(
                    Util.getFormattedDateEEEE(widget.e.date),
                    style: const TextStyle(
                        color: Util.dateTxtColor,
                        fontStyle: FontStyle.italic,
                        fontFamily: Util.dateFont),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListItemDeleteButton(
                  width: widget.maxWidth,
                  deleteTx: widget.deleteTransaction,
                  tx: widget.e,
                ),
                SizedBox(width: 5),
                ListItemEditButton(
                  width: widget.maxWidth,
                  editTx: widget.editTransaction,
                  tx: widget.e,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
