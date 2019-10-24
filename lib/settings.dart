import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/auth.dart';

enum location {
  commons, knollcrest, home, other
}

enum mealType {
  vegetarian, vegan, neither
}

class Settings extends StatelessWidget {
  Settings({this.auth});
  final BaseAuth auth;

  //Routename used for Navigation
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: MyStatefulWidget(auth: auth),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final BaseAuth auth;

  MyStatefulWidget({Key key, this.auth}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(auth: auth);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  // Default settings values
  String _location = "Other";
  String _mealType = "Vegan";
  int _mealsPerDay = 3;

  //function to handle the radio value change
  void _handleLocationValueChange(String value) {
    setState(() {
      _location = value;
    });
  }

  void _handleMealTypeChange(String value) {
    setState(() {
      _mealType = value;
    });
  }
  // authentication parameter
  final BaseAuth auth;

  //Static parameters for Drop Downs
  static double _iconSize = 24;
  static int _elevation = 16;
  static double _height = 2;

  _MyStatefulWidgetState({this.auth}) {
    // set settings to stored data
    _getUserData().then( (data) {
      setState(() {
        // TODO: have alternative display if user has never saved these settings (check for existance)
        _location = data['defaultLocation'];
        _mealsPerDay = data['mealsPerDay'];
        _mealType = data['defaultMealType'];
      });
    });
  }

  Future<DocumentSnapshot> _getUserData() async {
    return Firestore.instance.collection('users').document(await auth.getCurrentUser()).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            //Meals a Day
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Meals per Day:', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold,)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0)),
                  //Dropdown for how many meals per day
                  DropdownButton<String>(
                    value: _mealsPerDay.toString(),
                    icon: Icon(Icons.arrow_downward),
                    iconSize: _iconSize,
                    elevation: _elevation,
                    underline: Container(
                      height: _height,
                      color: Colors.green,
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
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),
                ]
            ),
            Text('Default Location:', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold,)),
            Padding( padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0,),
              child: Row( mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio( value: "Commons", groupValue: _location, onChanged: _handleLocationValueChange),
                  Text('Commons', style: TextStyle(fontSize: 16.0),),
                  Radio( value: "Knollcrest", groupValue: _location, onChanged: _handleLocationValueChange),
                  Text('Knollcrest', style: TextStyle(fontSize: 16.0),),
                ],),),
            Padding( padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0,),
                child: Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Radio( value: "Home", groupValue: _location, onChanged: _handleLocationValueChange),
                  Text('Home', style: TextStyle(fontSize: 16.0),),
                  Radio( value: "Other", groupValue: _location, onChanged: _handleLocationValueChange),
                  Text('Elsewhere', style: TextStyle(fontSize: 16.0),),
                ],)),
            Text('Default Meal Type', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold,)),
            Padding( padding: const EdgeInsets.all(10.0),
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio( value: "Vegetarian", groupValue: _mealType, onChanged: _handleMealTypeChange),
                    Text('Vegetarian', style: TextStyle(fontSize: 16.0),),
                    Radio( value: "Vegan", groupValue: _mealType, onChanged: _handleMealTypeChange),
                    Text('Vegan', style: TextStyle(fontSize: 16.0),),
                    Radio( value: "Neither", groupValue: _mealType, onChanged: _handleMealTypeChange),
                    Text('Neither', style: TextStyle(fontSize: 16.0),),
                  ],)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: new Text("Save Changes", style:TextStyle( color: Colors.green, fontWeight: FontWeight.bold,)),
                  onPressed: () { _saveSettings(); },
                  color: Colors.white,
                ),
              ]
            ),
          ],
        ),
    );
  }

  void _saveSettings() async {
    // save meals per day, default location, and default meal type
    Firestore.instance.collection('users').document(await auth.getCurrentUser()).updateData({
      'mealsPerDay': _mealsPerDay,
      'defaultLocation': _location,
      'defaultMealType': _mealType});
  }
}
