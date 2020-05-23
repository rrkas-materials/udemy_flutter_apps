import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';

import '../utils.dart';

class MealItem extends StatelessWidget {
  final Meal meal;

//  final Function removeMeal;

  const MealItem({
    Key key,
    this.meal,
//    this.removeMeal,
  }) : super(key: key);

  String get _mealComplexityText {
    switch (meal.complexity) {
      case Complexity.Simple:
        return 'Simple';
        break;
      case Complexity.Challenging:
        return 'Challenging';
        break;
      case Complexity.Hard:
        return 'Hard';
        break;
      default:
        return '';
    }
  }

  String get _mealAffordabilityText {
    switch (meal.affordability) {
      case Affordability.Affordable:
        return 'Affordable';
        break;
      case Affordability.Pricey:
        return 'Pricey';
        break;
      case Affordability.Luxurious:
        return 'Luxurious';
        break;
      default:
        return '';
    }
  }

  void selectMeal(context) {
    Navigator.of(context)
        .pushNamed(
      MEALS_DETAIL_SCREEN_ROUTE,
      arguments: meal,
    );
//        .then((popResult) {
//      if (popResult != null) removeMeal(popResult);
//      print(popResult);
//    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15.0);
    final radius = Radius.circular(15.0);
    final double imgHeight = 150, imgWidth = double.infinity;
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: radius,
                    topRight: radius,
                  ),
                  child: Image.network(
                    meal.imageUrl,
                    height: imgHeight,
                    width: imgWidth,
                    fit: BoxFit.cover, //resize and crop image
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 250,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      meal.title,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.schedule),
                      SizedBox(width: 6),
                      Text('${meal.duration.toString()} min'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.work),
                      SizedBox(width: 6),
                      Text('$_mealComplexityText'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.attach_money),
                      SizedBox(width: 6),
                      Text('$_mealAffordabilityText'),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
