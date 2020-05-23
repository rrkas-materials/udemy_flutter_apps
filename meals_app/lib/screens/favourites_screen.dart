import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/widgets/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> meals;

  FavoritesScreen(this.meals);

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty)
      return Center(
        child: Text('favs'),
      );
    else
      return ListView.builder(
        itemBuilder: (ctx, idx) {
          return MealItem(
            meal: meals[idx],
//            removeMeal: _removeMeal,
          );
        },
        itemCount: meals.length,
      );
  }
}
