import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cart_item_widget.dart';

class CartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
                if (cartProvider.getItemCount == 0) return;
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Are you Sure?'),
                          content: Text('Do you want to clear the cart?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                cartProvider.clear();
                                Navigator.of(ctx).pop();
                              },
                              child: Text('Yes'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('No'),
                            ),
                          ],
                        ));
              })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
//                  SizedBox(width: 10),
                  Spacer(),
                  Chip(
                    label: Text(
                      'RS. ${cartProvider.totAmt.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartProvider: cartProvider),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.getItemCount,
              itemBuilder: (ctx, idx) => CartItemWidget(
                cart: cartProvider.getItems.values.toList()[idx],
                productId: cartProvider.getItems.keys.toList()[idx],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartProvider,
  }) : super(key: key);

  final Cart cartProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartProvider.totAmt <= 0 || isloading)
          ? null
          : () async {
              setState(() {
                isloading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartProvider.getItems.values.toList(),
                widget.cartProvider.totAmt,
              );
              setState(() {
                isloading = false;
              });
              widget.cartProvider.clear();
            },
      child: isloading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
