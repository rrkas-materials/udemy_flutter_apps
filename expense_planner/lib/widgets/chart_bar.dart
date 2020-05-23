import 'package:flutter/cupertino.dart';

import '../util.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double amount;
  final double percent;
  final Color barColor;
  final double maxVerSize;

  const ChartBar({
    this.label,
    this.amount,
    this.percent,
    this.barColor,
    this.maxVerSize,
  });

  @override
  Widget build(BuildContext context) {
    final sizedBoxSize = maxVerSize * 0.01;
    final textBoxSize = maxVerSize * 0.15;
    final contentSize = maxVerSize * 0.68 -
        (MediaQuery.of(context).orientation == Orientation.landscape ? 5 : 0);
    final sizedBox = SizedBox(height: sizedBoxSize);
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        child: Card(
          elevation: 0.2,
          color: Util.chartBarCoverColor,
          child: Container(
            height: maxVerSize,
            padding: EdgeInsets.symmetric(horizontal: 1.5),
            width: constraints.maxWidth/50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 1),
                  height: textBoxSize,
                  child: Container(
                      //color: amount>0 ? Util.chartCardColor : Util.chartBarCoverColor,
                      child: Text(
                        '${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: Util.titleFont,
                          color: amount > 0 ? Util.deleteIconColor : Colors.black,
                          fontWeight: amount > 0 ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                ),
                sizedBox,
                Container(
                  height: contentSize,
                  width: 5.5,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Util.chartBarBgColor, width: 1),
                            color: Util.chartBarBgColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      FractionallySizedBox(
                        heightFactor: percent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],
                  ),
                ),
                sizedBox,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: textBoxSize,
                      child: FittedBox(
                        child: Text(
                          label,
                        ),
                      ),
                    ),
                    amount > 0
                        ? Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: const CircleAvatar(
                              radius: 2.5,
                              backgroundColor: Util.deleteIconColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
