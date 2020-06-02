import 'package:expenseplanner/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './adapive_button.dart';
import '../util.dart';

class AddModifyTransaction extends StatefulWidget {
  final Function function;
  final Transaction transaction;

  AddModifyTransaction(this.function, [this.transaction]);

  @override
  _AddModifyTransactionState createState() => _AddModifyTransactionState();
}

class _AddModifyTransactionState extends State<AddModifyTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    var enteredTitle = _titleController.text;
    if (_amountController.text.isEmpty) return;
    var enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.trim().isEmpty ||
        enteredAmount <= 0 ||
        _selectedDate == null) return;

    enteredTitle = enteredTitle.trim();

    if (widget.transaction != null)
      widget.function(
        Transaction(
          id: widget.transaction.id,
          title: enteredTitle,
          amount: enteredAmount,
          date: _selectedDate,
        ),
      );
    else
      widget.function(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() => _selectedDate = pickedDate);
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        if (widget.transaction != null) {
          _titleController.text = widget.transaction.title;
          _amountController.text = widget.transaction.amount.toString();
          _selectedDate = widget.transaction.date;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    final amtFocus = FocusNode();
    final mq = MediaQuery.of(context);
    return Card(
      elevation: 5,
      child: Container(
        height: 250 +
            (mq.orientation == Orientation.portrait ? 0 : 100) +
            (mq.viewInsets.bottom + mq.padding.bottom) * 2,
        padding:
            const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
//              onSubmitted: (_) => _submitData(),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount'),
//              onSubmitted: (_) => _submitData(),
                controller: _amountController,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No date chosen!'
                          : 'Picked date: \n${Util.getFormattedDateE(_selectedDate)}'),
                    ),
                    AdaptiveButton(onPressed: _presentDatePicker),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  color: Util.addBtnBgColor,
                  child: const Text(
                    'Add Transaction',
                    style: const TextStyle(
                      color: Util.addBtnTxtColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: _submitData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
