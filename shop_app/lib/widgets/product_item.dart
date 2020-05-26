import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../utils/routes_names.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
                RouteNames.PRODUCT_DETAIL_SCREEN_ROUTE,
                arguments: product.id);
            //whole product could also be forwarded, but following tutorial...
          },
          child: FadeInImage(
            placeholder: AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(product.imageURL),
            fit: BoxFit.cover,
          ),
        ),
        footer: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (_, product, __) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavStatus(auth.token, auth.uid);
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('snackbar'),
                  duration: Duration(seconds: 20),
                  action: SnackBarAction(
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                    label: 'UNDO',
                    textColor: Colors.yellow,
                  ),
                ));
              },
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
    );
  }
}
