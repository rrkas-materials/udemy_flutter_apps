import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/carts_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/products_detail_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';
import 'package:shopapp/utils/routes_names.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: ProductsProvider()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: AuthScreen(),
        routes: {
          PRODUCT_DETAIL_SCREEN_ROUTE: (_) => ProductsDetailScreen(),
          CART_SCREEN_ROUTE: (_) => CartsScreen(),
          ORDERS_SCREEN_ROUTE: (_) => OrdersScreen(),
          USER_PRODUCTS_SCREEN_ROUTE: (_) => UserProductsScreen(),
          EDIT_PRODUCT_SCREEN_ROUTE: (_) => EditProductScreen(),
          AUTH_ROUTE: (_) => AuthScreen()
        },
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
