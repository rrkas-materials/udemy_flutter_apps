import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/models/place.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items => [..._items];

  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String IMAGE = 'image';

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id, orElse: () => null);
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      title: title,
      location: null,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    DbHelper.insert('user_places', {
      ID: newPlace.id,
      TITLE: newPlace.title,
      IMAGE: newPlace.image.path,
    });
  }

  Future<void> fetchAndSet() async {
    final datalist = await DbHelper.getData('user_places');
    _items = datalist
        .map(
          (item) => Place(
            id: item[ID],
            title: item[TITLE],
            location: null,
            image: File(item[IMAGE]),
          ),
        )
        .toList();
    notifyListeners();
  }
}
