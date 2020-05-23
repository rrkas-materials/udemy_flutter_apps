import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/widgets/meal_item.dart';
import '../models/category.dart';
//import '../dummy_categories_data.dart';

class CategoryMealsScreen extends StatefulWidget {
  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

//  CategoryMealsScreen(this.category);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  Category category;
  List<Meal> meals;
  var loadedInitData = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!loadedInitData) {
      category = (ModalRoute.of(context).settings.arguments
          as Map<String, Category>)['category'];
      meals = widget.availableMeals
          .where((element) => element.categories.contains(category.id))
          .toList();
      loadedInitData = true;
    }
    super.didChangeDependencies();
  }

//  void _removeMeal(String mealId) {
//    setState(() {
//      meals.removeWhere((element) => element.id == mealId);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemBuilder: (ctx, idx) {
            return MealItem(
              meal: meals[idx],
//              removeMeal: _removeMeal,
            );
          },
          itemCount: meals.length,
        ),
      ),
    );
  }
}
