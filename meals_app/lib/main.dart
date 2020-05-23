import 'package:flutter/material.dart';
import 'package:mealsapp/dummy_categories_data.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/screens/meal_detail_screen.dart';
import 'package:mealsapp/screens/settings_screen.dart';
import 'package:mealsapp/screens/tabs_screen.dart';
import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import 'package:mealsapp/utils.dart';

void main() => runApp(MyApp());
//String title = 'Meals App';

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static const glutin = 'gluten';
  static const lactose = 'lactose';
  static const vegetarian = 'vegetarian';
  static const vegan = 'vegan';

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  Map<String, bool> _settings = {
    glutin: false,
    lactose: false,
    vegetarian: false,
    vegan: false,
  };

  void _setSettings(Map<String, bool> settingsData) {
    setState(() {
      _settings = settingsData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_settings[glutin] && !meal.isGlutenFree) return false;
        if (_settings[lactose] && !meal.isLactoseFree) return false;
        if (_settings[vegan] && !meal.isVegan) return false;
        if (_settings[vegetarian] && !meal.isVegetarian) return false;
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final idx = _favoriteMeals.indexWhere((element) => element.id == mealId);
    if (idx > -1) {
      setState(() {
        _favoriteMeals.removeAt(idx);
      });
    } else {
      setState(() {
        _favoriteMeals
            .add(DUMMY_MEALS.firstWhere((element) => element.id == mealId));
      });
    }
  }

  bool _isMealFavourite(String mealId) {
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            headline6: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed')),
      ),
      initialRoute: TABS_SCREEN_ROUTE,
      routes: {
        TABS_SCREEN_ROUTE: (_) => TabsScreen(favoriteMeals: _favoriteMeals),
        //works as home
        CATEGORY_SCREEN_ROUTE: (_) => CategoryMealsScreen(_availableMeals),
        MEALS_DETAIL_SCREEN_ROUTE: (_) =>
            MealDetailScreen(_toggleFavorite, _isMealFavourite),
        SETTINGS_SCREEN_ROUTE: (_) => SettingsScreen(_settings, _setSettings),
      },
      onUnknownRoute: (settings) {
        print(settings.arguments.toString());
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}
