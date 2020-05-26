import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../utils/routes_names.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
//    final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(RouteNames.EDIT_PRODUCT_SCREEN_ROUTE);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Consumer<ProductsProvider>(
                        builder: (ctx, productsProvider, _) => ListView.builder(
                            itemCount: productsProvider.getItems.length,
                            itemBuilder: (_, idx) => Column(
                                  children: <Widget>[
                                    UserProductItem(
                                      product: productsProvider.getItems[idx],
                                    ),
                                    Divider(),
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
