import 'dart:collection';
import 'package:expenseplanner/util.dart';
import './chart_bar.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  final List<Transaction> recentTransactions;
  final double maxVerSize;
  final double maxHorSize;

  const Chart(
    this.recentTransactions,
    this.maxVerSize,
    this.maxHorSize,
  );

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  bool _isAbsolute = false;

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totSum = 0.0;

      for (var i = 0; i < widget.recentTransactions.length; i++) {
        if (widget.recentTransactions[i].date.day == weekDay.day &&
            widget.recentTransactions[i].date.month == weekDay.month &&
            widget.recentTransactions[i].date.year == weekDay.year) {
          totSum += widget.recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totSum,
      };
    }).reversed.toList();
  }

  double get totSpending {
    return groupedTransaction.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  double get maxSpending {
    return getDistinct()[getDistinct().length - 1];
  }

  List<double> getDistinct() {
    List<double> values = [];
    for (var ele in groupedTransaction) {
      values.add(ele['amount']);
    }
    values = LinkedHashSet<double>.from(values).toList();
    values.sort();
    return values;
  }

  Color getBarColor(double barVal) {
    return barVal > 0 ? Util.bars[getDistinct().indexOf(barVal)] : Colors.white;
  }

  double _getPercent(double val) {
    return _isAbsolute
        ? (totSpending > 0 ? val / totSpending : 0)
        : (maxSpending > 0 ? val / maxSpending : 0);
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxSize = widget.maxVerSize * 0.02;
    final textBoxSize = widget.maxVerSize * 0.08;
    final contentSize = widget.maxVerSize * 0.62;
    final sizedbox = SizedBox(height: sizedBoxSize);
    return Card(
      color: Util.chartCardColor,
      elevation: 6,
      margin: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.only(top: 2, bottom: 0, right: 2, left: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: textBoxSize,
              child: FittedBox(
                child: const Text(
                  'Last 7 days spendings in Rupees :',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            sizedbox,
            Container(
              height: textBoxSize,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: const Text(
                      'Stats mode : ',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Switch.adaptive(
                      value: _isAbsolute,
                      onChanged: (val) {
                        setState(() {
                          _isAbsolute = val;
                        });
                      }),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        FittedBox(
                            child: Text(
                          'Absolute',
                          style: TextStyle(
                              color: _isAbsolute
                                  ? Util.statsActiveMode
                                  : Util.statsInactiveMode),
                        )),
                        const SizedBox(width: 5),
                        FittedBox(
                            child: Text(
                          'Relative',
                          style: TextStyle(
                              color: _isAbsolute
                                  ? Util.statsInactiveMode
                                  : Util.statsActiveMode),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            sizedbox,
            Container(
              height: contentSize,
//              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: groupedTransaction.map((data) {
                  return Expanded(
                    child: ChartBar(
                      label: data['day'],
                      amount: data['amount'],
                      percent: _getPercent((data['amount'] as double)),
                      barColor: getBarColor(data['amount'] as double),
                      maxVerSize: contentSize - 10,
//                      maxHorSize:widget.maxHorSize,
                    ),
                  );
                }).toList(),
              ),
            ),
            sizedbox,
            Container(
              height: textBoxSize,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Total spent : ',
                      style: TextStyle(fontSize: 20, color: Util.titleTxtColor),
                    ),
                    Text(
                      'Rs. ${totSpending.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: Util.titleFont,
                          color: Util.deleteIconColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
