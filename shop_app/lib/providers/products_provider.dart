import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/exceptions/http_exception.dart';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  static const ID = 'id';
  static const TITLE = 'title';
  static const DESC = 'desc';
  static const PRICE = 'price';
  static const URL = 'url';

//  static const IS_FAV = 'isFav';
  static const _CREATOR_ID = 'creatorId';

  final String _authToken;
  final String _uid;

  ProductsProvider(this._authToken, this._uid, this._items);

  List<Product> _items = [];

  //    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      desc: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageURL:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      desc: 'A nice pair of trousers.',
//      price: 59.99,
//      imageURL:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      desc: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageURL:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      desc: 'Prepare any meal you want.',
//      price: 149.99,
//      imageURL:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),

//  var _showFavOnly = false;

  List<Product> get getItems => [..._items];

  //    if (_showFavOnly) {
//      return _items.where((element) => element.isFavourite).toList();
//    }

  List<Product> get favItems {
    return _items.where((element) => element.isFavourite).toList();
  }

//  void showFavOnly(){
//    _showFavOnly=true;
//    notifyListeners();
//  }
//  void showAll(){
//    _showFavOnly=false;
//    notifyListeners();
//  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="$_CREATOR_ID"&equalTo="$_uid"' : '';
    var url = 'https://shop-app-41486.firebaseio.com/products'
        '.json?auth=$_authToken$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) return;
      url =
          'https://shop-app-41486.firebaseio.com/userFavorites/$_uid.json?auth=$_authToken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      extractedData.forEach((id, prodData) {
        loadedProducts.add(
          Product(
            id: id,
            title: prodData[TITLE],
            desc: prodData[DESC],
            price: prodData[PRICE],
            imageURL: prodData[URL],
            isFavourite: favData == null ? false : favData[id] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future<void> addProducts(Product product) async {
    final url = 'https://shop-app-41486.firebaseio.com/products'
        '.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          TITLE: product.title,
          DESC: product.desc,
          PRICE: product.price,
          URL: product.imageURL,
          _CREATOR_ID: _uid,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        desc: product.desc,
        price: product.price,
        imageURL: product.imageURL,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(Product product) async {
    final idx = _items.indexWhere((element) => element.id == product.id);
    if (idx >= 0) {
      final url = 'https://shop-app-41486.firebaseio.com/products/${product.id}'
          '.json?auth=$_authToken';
      http.patch(url,
          body: json.encode({
            TITLE: product.title,
            DESC: product.desc,
            URL: product.imageURL,
            PRICE: product.price,
//        IS_FAV:product.isFavourite,
          }));
      _items[idx] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    final url = 'https://shop-app-41486.firebaseio.com/products/${product.id}'
        '.json?auth=$_authToken';
    final existingIdx = _items.indexWhere(
      (element) => element.id == product.id,
    );
    var existingProduct = product;
    existingProduct = null;
    _items.removeAt(existingIdx);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingIdx, existingProduct);
      notifyListeners();
      throw HTTPException('Couldnt delete product');
    }
    notifyListeners();
  }
}
