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
      appBar: AppBar(
        title: FittedBox(child: Text(product.title)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            FittedBox(
              child: Text('Rs. ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 20)),
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
          ],
        ),
      ),
    );
  }
}
