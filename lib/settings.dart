import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/auth.dart';

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

  int _radioValue2 = -1;
  int _radioValue3 = -1;

  //function to handle the radio value change
  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;
    });}

    void _handleRadioValueChange3(int value) {
    setState(() {
      _radioValue3 = value;
    });}
  // authentication parameter
  final BaseAuth auth;

  //Static parameters for Drop Downs
  static double _iconSize = 24;
  static int _elevation = 16;
  static double _height = 2;

  //Default values for Drop Downs
  String _mealsPerDay = '3'; // TODO: set to user's setting

  _MyStatefulWidgetState({this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            //Meals a Day
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Meals per Day:', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold,)),
                  //Dropdown for how many meals per day
                  DropdownButton<String>(
                    value: _mealsPerDay,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: _iconSize,
                    elevation: _elevation,
                    underline: Container(
                      height: _height,
                      color: Colors.green,
                    ),
                    onChanged: (String newValue){
                      setState(() {
                        _mealsPerDay = newValue;
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
                child: Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Radio( value: 0, groupValue: _radioValue2, onChanged: _handleRadioValueChange2),
                    Text('Commons', style: TextStyle(fontSize: 16.0),),
                    Radio( value: 1, groupValue: _radioValue2, onChanged: _handleRadioValueChange2),
                    Text('Knollcrest', style: TextStyle(fontSize: 16.0),),
                    ],),),
            Padding( padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0,),
                child: Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Radio( value: 2, groupValue: _radioValue2, onChanged: _handleRadioValueChange2),
                    Text('Home', style: TextStyle(fontSize: 16.0),),
                    Radio( value: 3, groupValue: _radioValue2, onChanged: _handleRadioValueChange2),
                    Text('Elsewhere', style: TextStyle(fontSize: 16.0),),
                ],)),
            Text('Default Meal Type', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold,)),
            Padding( padding: const EdgeInsets.all(10.0),
            child: Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Radio( value: 0, groupValue: _radioValue3, onChanged: _handleRadioValueChange3),
              Text('Vegetarian', style: TextStyle(fontSize: 16.0),),
              Radio( value: 1, groupValue: _radioValue3, onChanged: _handleRadioValueChange3),
              Text('Vegan', style: TextStyle(fontSize: 16.0),),
              Radio( value: 2, groupValue: _radioValue3, onChanged: _handleRadioValueChange3),
              Text('Neither', style: TextStyle(fontSize: 16.0),),
            ],)),
            Row(
              children: [
                RaisedButton(
                  child: new Text("Save"),
                  onPressed: () { _saveSettings(); },
                ),
              ]
            ),
          ],
        ),
    );
  }

  void _saveSettings() async {
    // save meals per day
    Firestore.instance.collection('users').document(await auth.getCurrentUser()).updateData({'mealsPerDay': _mealsPerDay});

    // TODO: save other settings in the same command
  }
}