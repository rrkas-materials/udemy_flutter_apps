import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
//import 'package:shopapp/providers/product.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cart;
  final String productId;

  const CartItemWidget({Key key, this.cart, this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (dir) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(cart.id),
      confirmDismiss: (dir) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from cart?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('No')),
              FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text('Yes')),
            ],
          ),
        );
      },
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Chip(
              label: Container(
                width: 50,
                child: FittedBox(
                  child: Text(
                    'Rs. ${cart.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.3),
            ),
            title: Text('${cart.title}'),
            subtitle: Text('Total: Rs. ${cart.price * cart.qty}'),
            trailing: Text(
              '${cart.qty} x',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
