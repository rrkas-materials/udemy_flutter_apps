import 'package:flutter/material.dart';
import 'package:great_places/providers/places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your places',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).fetchAndSet(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<Places>(
                    child: const Text('No places added!'),
                    builder: (BuildContext context, value, Widget child) =>
                        value.items.length == 0
                            ? Center(child: child)
                            : ListView.builder(
                                itemCount: value.items.length,
                                itemBuilder: (ctx, idx) => ListTile(
                                  leading: Hero(
                                    tag: value.items[idx].id,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          FileImage(value.items[idx].image),
                                    ),
                                  ),
                                  title: Text(value.items[idx].title),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        PlaceDetailScreen.routeName,
                                        arguments: value.items[idx].id);
                                  },
                                ),
                              ),
                  ),
      ),
    );
  }
}
