//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/utils/routes_names.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Container(
          width: 100,
          child: Text(
            product.title,
            softWrap: true,
          )),
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageURL)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                    RouteNames.EDIT_PRODUCT_SCREEN_ROUTE,
                    arguments: product);
              }),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(product);
                } catch (e) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting Failed',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
