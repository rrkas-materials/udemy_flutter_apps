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

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      title: title,
      location: null,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    DbHelper.insert('places', {
      ID: newPlace.id,
      TITLE: newPlace.title,
      IMAGE: newPlace.image.path,
    });
  }
}
