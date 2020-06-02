import 'package:flutter/material.dart';

import './list_item.dart';
import '../models/transaction.dart';
import '../util.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction, editTransaction;
  final double maxHeight;
  final double maxWidth;
  final bool isLandscape;

  const TransactionList(this.transactions, this.deleteTransaction,
      this.editTransaction, this.maxHeight, this.maxWidth, this.isLandscape);

  @override
  Widget build(BuildContext context) {
    final noTransaction = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: maxHeight * 0.1 - (isLandscape ? 10 : 2),
          child: const Text(
            'No transactions yet!',
            style: TextStyle(color: Util.noTransactionColor),
          ),
        ),
        SizedBox(height: maxHeight * 0.1 - (isLandscape ? 10 : 2)),
        Container(
          height: maxHeight * 0.7 - (isLandscape ? 10 : 2),
          child: Image.asset(
            'assets/images/waiting.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
    return Container(
        child: transactions.isEmpty
            ? noTransaction
            : ListView(
                children:
//                itemBuilder: (_, idx) {
//                  final e = transactions[idx];
                    transactions
                        .map(
                          (e) => ListItem(
                            key: ValueKey(e.id),
                            e: e,
                            deleteTransaction: deleteTransaction,
                            editTransaction: editTransaction,
                            maxWidth: maxWidth * 0.9,
                          ),
                        )
                        .toList()

//                },
//                itemCount: transactions.length,
                ));
  }
}
