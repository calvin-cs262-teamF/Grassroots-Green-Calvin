/*  settings.dart
*
* A class used to set default values for meal logs to simply the meal logging process for users
*
*/
import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatelessWidget {
  /// Settings page of the app.

  /// Authenticator with user information.
  final BaseAuth auth;

  /// Constructor for Settings.
  Settings({this.auth});

  /// Route name for navigation to settings page
  static const String routeName = "/settings";

  /// Builds the Settings page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).primaryColor,),),
          backgroundColor: Theme.of(context).accentColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
        ),
        body: SettingsStatefulWidget(auth: auth),
    );
  }
}

class SettingsStatefulWidget extends StatefulWidget {
  /// StatefulWidget of the Settings page

  /// Authenticator with user information
  final BaseAuth auth;

  /// Constructor for settings StatefulWidget.
  SettingsStatefulWidget({Key key, this.auth}) : super(key: key);

  /// Creates the state for Settings.
  @override
  _SettingsStatefulWidgetState createState() => _SettingsStatefulWidgetState(auth: auth);
}

class _SettingsStatefulWidgetState extends State<SettingsStatefulWidget> {
  /// State of the Settings page.

  /// Authenticator with user information.
  final BaseAuth auth;

  /// Location selected for default setting.
  String _location = "Other";
  /// Meal type selected for default setting.
  String _mealType = "Vegan";
  /// Meals per day selected for default setting.
  int _mealsPerDay = 3;

  /// Icon size for drop down menus.
  static double _iconSize = 24;
  /// Elevation for drop down menus.
  static int _elevation = 16;
  /// Height for drop down menus.
  static double _height = 2;
  /// Padding Value
  static const double _padding = 8.0;

  /// Constructor for Setting's state.
  _SettingsStatefulWidgetState({this.auth}) {
    // set settings to stored data
    _getUserDocument().then( (data) {
      setState(() {
        if (data != null && data.exists) {
          if (data['defaultLocation'] != null) {
            _location = data['defaultLocation'];
          }
          if (data['mealsPerDay'] != null) {
            _mealsPerDay = data['mealsPerDay'];
          }
          if (data['defaultMealType'] != null) {
            _mealType = data['defaultMealType'];
          }
        }
      });
    });
  }

  /// Handles change in _location.
  void _handleLocationValueChange(String value) {
    setState(() {
      _location = value;
    });
  }

  /// Handles change in _mealType
  void _handleMealTypeChange(String value) {
    setState(() {
      _mealType = value;
    });
  }

  /// gets DocumentSnapshot with the data belonging to the logged in user.
  Future<DocumentSnapshot> _getUserDocument() async {
    DocumentSnapshot doc = await auth.getUserData();
    if(doc == null) {
      return null;
    }
    return (await auth.getUserData());
  }

  /// Builds the Settings page Scaffold for display.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Meals a Day
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: _padding),
                    child: Text('Meals per Day:', style: Theme.of(context).textTheme.display1),
                  ),
                  //Dropdown for how many meals per day
                  DropdownButton<String>(
                    value: _mealsPerDay.toString(),
                    icon: Icon(Icons.arrow_downward),
                    iconSize: _iconSize,
                    elevation: _elevation,
                    underline: Container(
                      height: _height,
                      color: Theme.of(context).accentColor,
                    ),
                    onChanged: (String newValue){
                      setState(() {
                        _mealsPerDay = int.parse(newValue);
                      });
                    },
                    items: <String>['1', '2', '3', '4', '5', '6']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: Theme.of(context).textTheme.display2,),
                      );
                    })
                        .toList(),
                  ),
                ]
            ),
            Padding(
              padding: const EdgeInsets.all(_padding),
              //alignment: Alignment.centerLeft,
              child: Text('Default Location:', style: Theme.of(context).textTheme.display1,),
            ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0,),
                child: Row( mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio( value: "Commons", groupValue: _location, onChanged: _handleLocationValueChange, activeColor: Theme.of(context).accentColor),
                    Text('Commons', style: Theme.of(context).textTheme.display2,),
                    Radio( value: "Knollcrest", groupValue: _location, onChanged: _handleLocationValueChange, activeColor: Theme.of(context).accentColor),
                    Text('Knollcrest', style: Theme.of(context).textTheme.display2,),
                ],),),
            Padding( padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0,),
                child: Row( mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                  Radio( value: "Home", groupValue: _location, onChanged: _handleLocationValueChange, activeColor: Theme.of(context).accentColor),
                  Text('Home', style: Theme.of(context).textTheme.display2,),
                  Radio( value: "Other", groupValue: _location, onChanged: _handleLocationValueChange, activeColor: Theme.of(context).accentColor),
                  Text('Other', style: Theme.of(context).textTheme.display2),
                ],)),
            Padding(
              padding: EdgeInsets.all(_padding),
              child: Text('Default Meal Type:', style: Theme.of(context).textTheme.display1,),
            ),
              Padding( padding: const EdgeInsets.all(8.0),
                child: Row( mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio( value: "Vegetarian", groupValue: _mealType, onChanged: _handleMealTypeChange, activeColor: Theme.of(context).accentColor),
                    Text('Vegetarian', style: Theme.of(context).textTheme.display2,),
                    Radio( value: "Vegan", groupValue: _mealType, onChanged: _handleMealTypeChange, activeColor: Theme.of(context).accentColor),
                    Text('Vegan', style: Theme.of(context).textTheme.display2,),
                    Radio( value: "Neither", groupValue: _mealType, onChanged: _handleMealTypeChange, activeColor: Theme.of(context).accentColor),
                    Text('Neither', style: Theme.of(context).textTheme.display2,),
                  ],)),

            //TODO: Here's a question from Sam: Do we need a button here? could we have it save the settings when a user navigates away from the settings page?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: new Text("Save Changes", style:TextStyle( color: Theme.of(context).primaryColor,)),
                  onPressed: () { _saveSettings(); },
                  color: Theme.of(context).accentColor,
                ),
              ]
            ),
          ],
        ),
    );
  }

  /// Saves the settings to Firestore.
  void _saveSettings() async {
    String saveMessage = "";
    try {
      await Firestore.instance.collection('users').document(
          await auth.getCurrentUser()).updateData({
        'mealsPerDay': _mealsPerDay,
        'defaultLocation': _location,
        'defaultMealType': _mealType,
      });
      saveMessage = "Saved settings.";
    } catch(e) {
      saveMessage = "Error saving settings.";
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(saveMessage),
    ));
  }
}
