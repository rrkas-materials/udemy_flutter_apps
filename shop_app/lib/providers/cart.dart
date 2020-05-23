import 'package:flutter/material.dart';
import '../providers/product.dart';

class CartItem {
  static const ID = 'id';
  static const TITLE = 'title';
  static const QUANTITY = 'quantity';
  static const PRICE = 'price';

  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.qty,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get getItems {
    return {..._items};
  }

  double get totAmt {
    double tot = 0.0;
    _items.forEach((key, value) {
      tot += value.price * value.qty;
    });
    return tot;
  }

  int get getItemCount {
    return _items == null ? 0 : _items.length;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          qty: value.qty + 1,
          price: value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: product.title,
          qty: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) return;
    if (_items[productID].qty > 1) {
      _items.update(
        productID,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          qty: value.qty - 1,
          price: value.price,
        ),
      );
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
