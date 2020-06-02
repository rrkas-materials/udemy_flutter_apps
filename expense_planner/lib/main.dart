import 'dart:io';

import 'package:expenseplanner/helpers/local_db_helper.dart';
import 'package:expenseplanner/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './util.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';

void main() {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Planner',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [];
  bool _showChart = true;

//  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
//    Future.delayed(Duration.zero).then((_){
    LocalDbHelper.retrieveTransactions.then((trs) => _userTransactions = trs);
//    });
  }

  void deleteAll() {
    setState(() {
      _userTransactions = [];
    });
    LocalDbHelper.deleteAllRecords();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Transaction> get _sortedTransactions {
    return _userTransactions
      ..sort((a, b) {
        return a.date.millisecond > b.date.millisecond
            ? b.date.millisecond
            : a.date.millisecond;
      });
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
    LocalDbHelper.storeTransaction(newTx);
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
    LocalDbHelper.deleteTransactionById(id);
  }

  void _editTransaction(Transaction transaction) {
    setState(
      () {
        final idx = _userTransactions
            .indexWhere((element) => element.id == transaction.id);
        _userTransactions.removeAt(idx);
        _userTransactions.insert(idx, transaction);
      },
    );
    LocalDbHelper.updateTransaction(transaction);
  }

  void _startEditTransaction(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: AddModifyTransaction(_editTransaction, transaction),
        );
      },
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: AddModifyTransaction(_addNewTransaction),
        );
      },
    );
  }

  Widget _buildContent(Widget w1, Widget w2) {
    return Column(
      children: <Widget>[w1, w2],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    final mq = MediaQuery.of(context);
    final isLandscape = mq.orientation == Orientation.landscape;
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Expense Planner',
          style: TextStyle(
            fontFamily: Util.appBarFont,
            fontSize: 22,
            color: Colors.lightGreenAccent,
          ),
        ),
        Text(
          'Lets plan your Expenses',
          style: TextStyle(
              fontFamily: Util.appBarFont,
              fontSize: 14,
              color: Colors.yellow.shade200),
        ),
      ],
    );
    final PreferredSizeWidget appbar = isIos
        ? CupertinoNavigationBar(
            middle: title,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
                GestureDetector(
                  child: const Icon(CupertinoIcons.book_solid),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            backgroundColor: Util.appBarColor,
            title: title,
            actions: <Widget>[
              IconButton(
                onPressed: deleteAll,
                icon: Icon(Icons.delete_sweep),
              ),
//              IconButton(
//                icon: const Icon(Icons.event),
//                onPressed: () {},
//              )
            ],
          );
    final ded = appbar.preferredSize.height +
        (isLandscape ? mq.padding.right : mq.padding.top);
    final switchHeight = (mq.size.height - ded) * 0.085;
    final chrtHeight =
        (mq.size.height - ded) * (isLandscape ? 0.73 : 0.35) * 1.01;
    final listHeight =
        (mq.size.height - ded) * (isLandscape ? 0.8 : 0.6) * 1.01;
    final adaptiveSwitch = Container(
      height: switchHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Show Chart',
//            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
    );
    var chartLand = Container(
      height: chrtHeight,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Chart(_recentTransactions, constraints.maxHeight * 0.98,
              constraints.maxWidth);
        },
      ),
    );
    var chartPort = Container(
      height: chrtHeight,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Chart(
              _recentTransactions, constraints.maxHeight, constraints.maxWidth);
        },
      ),
    );
    final txListLand = Container(
        height: listHeight,
        child: LayoutBuilder(builder: (_, c) {
          return TransactionList(
            _sortedTransactions,
            _deleteTransaction,
            _startEditTransaction,
            c.maxHeight,
            c.maxWidth,
            isLandscape,
          );
        }));
    final txListPort = Container(
        height: listHeight,
        child: LayoutBuilder(builder: (_, c) {
          return TransactionList(
            _sortedTransactions,
            _deleteTransaction,
            _startEditTransaction,
            c.maxHeight,
            c.maxWidth,
            isLandscape,
          );
        }));

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            isLandscape
                ? _buildContent(
                    adaptiveSwitch,
                    (_showChart ? chartLand : txListLand),
                  )
                : _buildContent(
                    chartPort,
                    txListPort,
                  ),
            Container(
                height: (mq.size.height - ded) * (isLandscape ? 0.1 : 0.05),
                padding: const EdgeInsets.all(5),
                child: Row(children: <Widget>[
                  const Text(
                    'Made By Rohnak Agarwal,',
                  ),
                  const Text(
                    'rrka79wal@gmail.com',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  )
                ]))
          ],
        ),
      ),
    );
    return isIos
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appbar,
          )
        : Scaffold(
            appBar: appbar,
            floatingActionButton: isIos
                ? Container()
                : FloatingActionButton(
                    child: const Icon(
                      Icons.add,
                      color: Util.iconColor,
                    ),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            body: body,
//      resizeToAvoidBottomPadding: true,
          );
  }
}
