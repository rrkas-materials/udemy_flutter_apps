import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  static const ID = 'id';
  static const AMOUNT = 'amount';
  static const DATETIME = 'dateTime';
  static const PRODUCTS = 'products';

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  final String uid;

  Orders(this.authToken, this.uid, this._orders);

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shop-app-41486.firebaseio.com/orders/$uid'
        '.json?auth=$authToken';
    final response = await http.get(url);
    print(response.body);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((key, value) {
      loadedOrders.add(
        OrderItem(
          id: key,
          amount: value[OrderItem.AMOUNT],
          datetime: DateTime.parse(value[OrderItem.DATETIME]),
          products: (value[OrderItem.PRODUCTS] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e[CartItem.ID],
                  title: e[CartItem.TITLE],
                  qty: e[CartItem.QUANTITY],
                  price: e[CartItem.PRICE],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final url = 'https://shop-app-41486.firebaseio.com/orders/$uid'
        '.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          OrderItem.AMOUNT: total,
          OrderItem.DATETIME: timestamp.toIso8601String(),
          OrderItem.PRODUCTS: cartItems
              .map((cp) => {
                    CartItem.ID: cp.id,
                    CartItem.TITLE: cp.title,
                    CartItem.QUANTITY: cp.qty,
                    CartItem.PRICE: cp.price,
                  })
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartItems,
        datetime: timestamp,
      ),
    );
    notifyListeners();
  }
}
