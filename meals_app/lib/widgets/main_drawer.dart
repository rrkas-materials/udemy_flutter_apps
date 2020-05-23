import 'package:flutter/material.dart';

import '../utils.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildListTile(String title, IconData icon, Function onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme
                .of(context)
                .accentColor,
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme
                      .of(context)
                      .primaryColor),
            ),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 20),
          _buildListTile('Meals', Icons.restaurant, () {
            Navigator.of(context).pushReplacementNamed(TABS_SCREEN_ROUTE);
          }),
          _buildListTile("Settings", Icons.settings, (() {
            Navigator.of(context).pushReplacementNamed(SETTINGS_SCREEN_ROUTE);
          })),
        ],
      ),
    );
  }
}
