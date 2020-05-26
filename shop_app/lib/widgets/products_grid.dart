import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
//  const ProductsGrid({
//    Key key,
//    @required this.loadedProducts,
//  }) : super(key: key);
//
//  final List<Product> loadedProducts;

  final bool showFav;

  const ProductsGrid({Key key, this.showFav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFav ? productsData.favItems : productsData.getItems;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
          value: products[idx],
          child: ProductItem(
//              product: products[idx]
              )),
    );
  }
}
