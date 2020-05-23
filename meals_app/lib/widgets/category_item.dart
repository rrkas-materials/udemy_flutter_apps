import 'package:flutter/material.dart';
import '../utils.dart';

import '../models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key key, @required this.category}) : super(key: key);

  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      CATEGORY_SCREEN_ROUTE,
      arguments: {'category': category},
    );
  }

  @override
  Widget build(BuildContext context) {
    const height = 60.0, width = 20.0;
    const borderRadius = 15.0;
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(15),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.headline6,
        ),
//      color: category.color,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.7),
              category.color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
