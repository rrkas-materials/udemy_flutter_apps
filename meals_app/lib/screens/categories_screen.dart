import 'package:flutter/material.dart';
import '../widgets/category_item.dart';
import '../dummy_categories_data.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
//      Scaffold(
//      appBar: AppBar(
//        title: Text('Meals'),
//      ),
//      body:
        GridView(
      padding: const EdgeInsets.all(18),
      children: DUMMY_CATEGORIES
          .map(
            (e) => CategoryItem(category: e),
          )
          .toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2, // h/w
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
//      ),
    );
  }
}
