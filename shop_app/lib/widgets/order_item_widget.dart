//import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

//import '../providers/product.dart';
//import '../widgets/product_item.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;

  const OrderItemWidget({Key key, this.orderItem}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded ? widget.orderItem.products.length * 20.0 + 102.0 : 92.0,
      child: Card(
        shadowColor: Colors.black54,
        elevation: 5.0,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Rs. ${widget.orderItem.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy').format(widget.orderItem.datetime)),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height:
                  expanded ? widget.orderItem.products.length * 20.0 + 10.0 : 0,
              duration: Duration(milliseconds: 300),
              child: ListView.builder(
                itemCount: widget.orderItem.products.length,
                itemBuilder: (ctx, idx) {
                  final CartItem pro = widget.orderItem.products[idx];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        pro.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${pro.qty} x Rs. ${pro.price}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
