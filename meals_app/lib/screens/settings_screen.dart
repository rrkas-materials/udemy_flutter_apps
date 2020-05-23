import 'package:flutter/material.dart';
import 'package:mealsapp/main.dart';
import 'package:mealsapp/widgets/main_drawer.dart';

class SettingsScreen extends StatefulWidget {
  final Function setSettings;
  final Map<String, bool> currentSettings;
  SettingsScreen(this.currentSettings,this.setSettings);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _glutinfree = false;
  var _vegeterian = false;
  var _vegan = false;
  var _lactosefree = false;

  Widget _buildSwitchListTile(
      String title, String desc, bool val, Function onChanged) {
    return SwitchListTile(
      activeColor: Theme.of(context).primaryColor,
      title: Text(title),
      subtitle: Text(desc),
      value: val,
      onChanged: onChanged,
    );
  }

  @override
  void initState() {
    _glutinfree = widget.currentSettings[MyAppState.glutin];
    _lactosefree = widget.currentSettings[MyAppState.lactose];
    _vegeterian = widget.currentSettings[MyAppState.vegetarian];
    _vegan = widget.currentSettings[MyAppState.vegan];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Settings'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                final selectedFilters = {
                  MyAppState.glutin: _glutinfree,
                  MyAppState.lactose: _lactosefree,
                  MyAppState.vegetarian: _vegeterian,
                  MyAppState.vegan: _vegan
                };
                widget.setSettings(selectedFilters);
                print('saved');
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Adjust meal selection',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildSwitchListTile('Gluten-free',
                    'Only include glutin free meals', _glutinfree, (val) {
                  setState(() => _glutinfree = val);
                }),
                _buildSwitchListTile('Lactose-free',
                    'Only include lactose free meals', _lactosefree, (val) {
                  setState(() => _lactosefree = val);
                }),
                _buildSwitchListTile(
                    'Vegetarian', 'Only include vegetarian meals', _vegeterian,
                    (val) {
                  setState(() => _vegeterian = val);
                }),
                _buildSwitchListTile(
                    'Vegan', 'Only include vegan meals', _vegan, (val) {
                  setState(() => _vegan = val);
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
