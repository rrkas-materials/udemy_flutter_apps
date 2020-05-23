import 'dart:math';

import 'package:expenseplanner/widgets/item_delete_btn.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../util.dart';

class ListItem extends StatefulWidget {
  const ListItem(
      {Key key,
      @required this.e,
//    @required this.mq,
      @required this.deleteTransaction,
//    @required this.editTransaction,
      @required this.maxWidth})
      : super(key: key);

  final Transaction e;
//  final MediaQueryData mq;
  final Function deleteTransaction; //, editTransaction;
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
    final leadingWidth = widget.maxWidth * 0.2;
    final titleWidth = widget.maxWidth * 0.6;
    final trailingWidth = widget.maxWidth * 0.2;
    return Card(
      color: Util.rowCardColor,
      elevation: 3,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(width: 1),
            shape: BoxShape.circle,
          ),
          width: leadingWidth,
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
        title: Container(
          alignment: Alignment.centerLeft,
          width: titleWidth,
//                height: itemHeight * 0.3,
          child: FittedBox(
            child: Text(
              widget.e.title.toUpperCase(),
              style: const TextStyle(
                fontFamily: Util.titleFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Util.titleTxtColor,
              ),
            ),
          ),
        ),
        subtitle: Container(
          alignment: Alignment.centerLeft,
          width: titleWidth,
//                height: itemHeight * 0.3,
          child: FittedBox(
            child: Text(
              Util.getFormattedDateEEEE(widget.e.date),
              style: const TextStyle(
                  color: Util.dateTxtColor,
                  fontStyle: FontStyle.italic,
                  fontFamily: Util.dateFont),
            ),
          ),
        ),
        trailing: Container(
          width: trailingWidth,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListItemDeleteButton(
                width: widget.maxWidth,
                deleteTx: widget.deleteTransaction,
                tx: widget.e,
              ),
//              ListItemEditButton(width: widget.maxWidth,
////              editTx: widget.editTransaction,
//              tx: widget.e,)
            ],
          ),
        ),
      ),
    );
  }
}
