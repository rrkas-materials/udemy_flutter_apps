import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/auth_screen.dart';
import './screens/carts_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/products_detail_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_products_screen.dart';
import './utils/routes_names.dart';
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
            auth.uid,
            orders == null ? [] : orders.getOrders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
//            RouteNames.PRODUCT_OVERVIEW_SCREEN: (_) => ProductsOverviewScreen(),
            RouteNames.PRODUCT_DETAIL_SCREEN_ROUTE: (_) =>
                ProductsDetailScreen(),
            RouteNames.CART_SCREEN_ROUTE: (_) => CartsScreen(),
            RouteNames.ORDERS_SCREEN_ROUTE: (_) => OrdersScreen(),
            RouteNames.USER_PRODUCTS_SCREEN_ROUTE: (_) => UserProductsScreen(),
            RouteNames.EDIT_PRODUCT_SCREEN_ROUTE: (_) => EditProductScreen(),
//            RouteNames.AUTH_ROUTE: (_) => AuthScreen()
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
