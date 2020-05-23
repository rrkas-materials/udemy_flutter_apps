import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';

class MealDetailScreen extends StatelessWidget {
  final Function toggleFavorite, isMealFav;

  MealDetailScreen(this.toggleFavorite, this.isMealFav);

  Widget _buildSectionTitle(BuildContext ctx, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(ctx).textTheme.headline6,
      ),
    );
  }

  Widget _buildContainer(
    Widget child,
    double height,
    double width,
  ) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      height: height,
      width: width,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingrediantsListWidth = MediaQuery.of(context).size.width * 0.8;
    final stepsListWidth = MediaQuery.of(context).size.width * 0.9;
    Meal meal = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent.shade100,
        onPressed: () => toggleFavorite(meal.id),
        child: Icon(
          isMealFav(meal.id) ? Icons.star : Icons.star_border,
          color: Colors.deepOrange,
          size: 35,
        ),
      ),
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            meal.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            _buildSectionTitle(context, 'Ingrediants'),
            _buildContainer(
                ListView.builder(
                  itemBuilder: (ctx, idx) => Card(
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(
                        meal.ingredients[idx],
                      ),
                    ),
                  ),
                  itemCount: meal.ingredients.length,
                ),
                ingrediantsListWidth * 0.8,
                ingrediantsListWidth),
            _buildSectionTitle(context, 'Steps'),
            _buildContainer(
                ListView.builder(
                  itemBuilder: (ctx, idx) => Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Text('# ${idx + 1}'),
                        ),
                        title: Text(meal.steps[idx]),
                      ),
                      Divider(),
                    ],
                  ),
                  itemCount: meal.steps.length,
                ),
                stepsListWidth * 1.2,
                stepsListWidth)
          ],
        ),
      ),
    );
  }
}
