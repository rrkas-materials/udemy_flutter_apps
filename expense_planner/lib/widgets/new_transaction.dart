import './adapive_button.dart';
import 'package:flutter/cupertino.dart';
import '../util.dart';
import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

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

    widget.addNewTransaction(enteredTitle, enteredAmount, _selectedDate);

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
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    final amtFocus = FocusNode();
    final mq = MediaQuery.of(context);
    return Card(
      elevation: 5,
      child: Container(
        height: 250 + (mq.viewInsets.bottom + mq.padding.bottom) * 2,
        padding:
            const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
              onSubmitted: (_) => _submitData(),
              controller: _amountController,
            ),
            Expanded(
              child: Padding(
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
            ),
            Flexible(
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
