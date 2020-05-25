import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/carts_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/products_detail_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';
import 'package:shopapp/utils/routes_names.dart';

import 'providers/products_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/products_overview_screen.dart';
import 'utils/routes_names.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: null,
          update: (ctx, auth, prevProducts) => ProductsProvider(
            auth.token,
            auth.uid,
            prevProducts == null ? [] : prevProducts.getItems,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (ctx, auth, orders) => Orders(
            auth.token,
            orders == null ? [] : orders.getOrders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, value, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: value.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            RouteNames.PRODUCT_OVERVIEW_SCREEN: (_) => ProductsOverviewScreen(),
            RouteNames.PRODUCT_DETAIL_SCREEN_ROUTE: (_) =>
                ProductsDetailScreen(),
            RouteNames.CART_SCREEN_ROUTE: (_) => CartsScreen(),
            RouteNames.ORDERS_SCREEN_ROUTE: (_) => OrdersScreen(),
            RouteNames.USER_PRODUCTS_SCREEN_ROUTE: (_) => UserProductsScreen(),
            RouteNames.EDIT_PRODUCT_SCREEN_ROUTE: (_) => EditProductScreen(),
            RouteNames.AUTH_ROUTE: (_) => AuthScreen()
          },
        ),
      ),
    );
  }
}

//class MyHomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('MyShop'),
//      ),
//      body: Center(
//        child: Text('Let\'s build a shop!'),
//      ),
//    );
//  }
//}
