import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageURL;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.desc,
    @required this.price,
    @required this.imageURL,
    this.isFavourite = false,
  });

  Future<void> toggleFavStatus(String token, String userId) async {
    final url =
        'https://shop-app-41486.firebaseio.com/userFavorites/$userId/$id'
        '.json?auth=$token';
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
