import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/utils/routes_names.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/products_grid.dart';

enum FilterOptions { Fav, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavOnly = false;
  bool _isInit = true;
  bool _loading = false;

  @override
  void initState() {
//    Provider.of<ProductsProvider>(context).fetchAndSetProducts();
//    Future.delayed(Duration.zero).then(
//      (_) => Provider.of<ProductsProvider>(context)
//          .fetchAndSetProducts(),
//    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _loading = true);
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .then((_) => setState(() => _loading = false));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Fav,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions val) {
              setState(() {
                if (val == FilterOptions.Fav) {
                  _showFavOnly = true;
//                providerData.showFavOnly();
                } else {
                  _showFavOnly = false;
//                providerData.showAll();
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: IconButton(
                  icon: child,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(RouteNames.CART_SCREEN_ROUTE)),
              value: cart.getItemCount.toString(),
              color: Colors.orange,
            ),
            child: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFav: _showFavOnly),
    );
  }
}
