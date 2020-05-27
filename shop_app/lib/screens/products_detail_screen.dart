import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class ProductsDetailScreen extends StatelessWidget {
//  final Product product;
//
//  const ProductsDetailScreen({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final Product product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
//      appBar: AppBar(
//        title: FittedBox(child: Text(product.title)),
//      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title.substring(0, 1).toUpperCase() +
                    product.title.substring(1).toLowerCase(),
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Rs. ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    product.desc,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
