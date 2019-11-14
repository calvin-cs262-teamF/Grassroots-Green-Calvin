/*  eat.dart
*
* A class used to display EAT content
*
*/
import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Eat extends StatelessWidget {

  /// Routename used for Navigation
  static const String routeName = "/eat";

  /// Authenticator with user information.
  final BaseAuth auth;

  /// Constructor for Eat.
  Eat({this.auth});

  /// Builds the Eat page
  @override
  Widget build(BuildContext context) {
    return Container(
      child: EatStatefulWidget(auth: auth),
    );
  }
}

class EatStatefulWidget extends StatefulWidget {

  final BaseAuth auth;

  EatStatefulWidget({Key key, this.auth}) : super(key: key);

  @override
  EatStatefulWidgetState createState() => EatStatefulWidgetState(auth: auth);
}

class EatStatefulWidgetState extends State<EatStatefulWidget> {

  Container getEAT(BuildContext context){
     return Container(
       child: Stack(
           children: <Widget>[
             Container(
               height: 540,
               width: 420,
               decoration: BoxDecoration(
                   image: DecorationImage(
                       image: AssetImage('assets/learn_background/customgrass.PNG' ),
                       fit: BoxFit.cover)),),
             Padding(
                 padding:  EdgeInsets.symmetric(vertical: 152.0),                //TODO: This padding only moves the form down a bit. We want it centered on the page.
                 child: Padding(                                                 //TODO: This is just a cosmetic thing, but it would make the app look nicer.
                     padding:  EdgeInsets.symmetric(horizontal: 10.0),           //TODO: I tried using 'crossAxisAlignment: CrossAxisAlignment.center here, but it didn't work. IDK why
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Text('Record a Meal:',
                             style: Theme.of(context).textTheme.title),
                         Padding(padding: const EdgeInsets.all(10.0),
                             child: Row(mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                                 Radio(value: "Vegetarian",
                                     groupValue: _mealType,
                                     onChanged: _handleMealTypeChange),
                                 ButtonTheme(
                                     minWidth: 0.0,
                                     child: FlatButton(
                                       onPressed: () { _handleMealTypeChange("Vegetarian"); },
                                       padding: EdgeInsets.all(0),
                                       child: Text('Vegetarian', style: Theme.of(context).textTheme.display2),
                                     )),
                                 Radio(value: "Vegan",
                                     groupValue: _mealType,
                                     onChanged: _handleMealTypeChange),
                                 ButtonTheme(
                                     minWidth: 0.0,
                                     child: FlatButton(
                                       onPressed: () { _handleMealTypeChange("Vegan"); },
                                       padding: EdgeInsets.all(0),
                                       child: Text('Vegan', style: Theme.of(context).textTheme.display2),
                                     )),
                                 Radio(value: "Neither",
                                     groupValue: _mealType,
                                     onChanged: _handleMealTypeChange),
//                            Text('Neither', style: Theme.of(context).textTheme.display2),
                                 ButtonTheme(
                                     minWidth: 0.0,
                                     child: FlatButton(
                                       onPressed: () { _handleMealTypeChange("Neither"); },
                                       padding: EdgeInsets.all(0),
                                       child: Text('Neither', style: Theme.of(context).textTheme.display2),
                                     )),
                               ],
                             )
                         ),
                         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                           Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                             child: Text('Location:',
                                 style: Theme.of(context).textTheme.display1),
                           ),
                           //Dropdown for the location the meal has been eaten
                           Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                               child:DropdownButton<String>(
                                 value: _mealLocation,
                                 icon: Icon(Icons.arrow_downward),
                                 iconSize: _iconSize,
                                 elevation: _elevation,
                                 underline: Container(height: _height,
                                   color: Theme.of(context).accentColor,),
                                 onChanged: (String newValue) {
                                   setState(() {
                                     _mealLocation = newValue;
                                   });
                                 },
                                 items: <String>['Commons', 'Knollcrest', 'Home', 'Other']
                                     .map<DropdownMenuItem<String>>((String value) {
                                   return DropdownMenuItem<String>(
                                     value: value,
                                     child: Text(value,
                                         style: Theme.of(context).textTheme.display2),
                                   );
                                 }).toList(),
                               )
                           )
                         ]),
                         ///the button to submit the record of the eaten meal
                         Padding(padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                           child: Builder( // Note: be careful about this when refactoring. It was a bit weird to get it to work at all.
                             builder: (context) => RaisedButton(
                                 child: Text('Submit', style: TextStyle( color: Theme.of(context).primaryColor)),
                                 color: Theme.of(context).accentColor,
                                 onPressed: () {
                                   _submitForm(context, _mealType, _mealLocation);
                                 }),
                           ),
                         ),
                       ],
                     )
                 )
             )
           ]),);
  }

  final BaseAuth auth;

  /// Type of meal selected with radio button for meal submission.
  String _mealType = "NULL";
  /// Location of meal submitted by user.
  String _mealLocation = 'Commons';

  /// Size of icons on page
  static double _iconSize = 24;
  /// Elevation for dropdown buttons
  static int _elevation = 16;
  /// Height of buttons.
  static double _height = 2;

  EatStatefulWidgetState({this.auth}) {;}

  /// Modifies the meal type when value is changed by user.
  void _handleMealTypeChange(String value) {
    setState(() {
      _mealType = value;
    });
  }

  /// Submit form and save to database.
  void _submitForm(BuildContext snackContext, String type, String location) async {
    String snackMessage = "";
    try {
      await Firestore.instance.collection('users').document(
          await auth.getCurrentUser()).collection('meals').document().setData({
        'type': type,
        'location': location,
        'time': FieldValue.serverTimestamp()
      });
      await Firestore.instance.collection('users').document(
          await auth.getCurrentUser()).updateData({
        'Count': FieldValue.increment(1),
        '$type': FieldValue.increment(1),
      });
      snackMessage = "Meal saved.";
    } catch(e) {
      print("ERROR SAVING MEAL");
      snackMessage = "Error saving meal.";
    }
    Scaffold.of(snackContext).showSnackBar(new SnackBar(content: new Text(snackMessage)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          children: <Widget>[
            Container(
              height: 540,
              width: 420,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/learn_background/customgrass.PNG' ),
                      fit: BoxFit.cover)),),
            Padding(
                padding:  EdgeInsets.symmetric(vertical: 152.0),                //TODO: This padding only moves the form down a bit. We want it centered on the page.
                child: Padding(                                                 //TODO: This is just a cosmetic thing, but it would make the app look nicer.
                    padding:  EdgeInsets.symmetric(horizontal: 10.0),           //TODO: I tried using 'crossAxisAlignment: CrossAxisAlignment.center here, but it didn't work. IDK why
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Record a Meal:',
                            style: Theme.of(context).textTheme.title),
                        Padding(padding: const EdgeInsets.all(10.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Radio(value: "Vegetarian",
                                    groupValue: _mealType,
                                    onChanged: _handleMealTypeChange),
                                ButtonTheme(
                                    minWidth: 0.0,
                                    child: FlatButton(
                                      onPressed: () { _handleMealTypeChange("Vegetarian"); },
                                      padding: EdgeInsets.all(0),
                                      child: Text('Vegetarian', style: Theme.of(context).textTheme.display2),
                                    )),
                                Radio(value: "Vegan",
                                    groupValue: _mealType,
                                    onChanged: _handleMealTypeChange),
                                ButtonTheme(
                                    minWidth: 0.0,
                                    child: FlatButton(
                                      onPressed: () { _handleMealTypeChange("Vegan"); },
                                      padding: EdgeInsets.all(0),
                                      child: Text('Vegan', style: Theme.of(context).textTheme.display2),
                                    )),
                                Radio(value: "Neither",
                                    groupValue: _mealType,
                                    onChanged: _handleMealTypeChange),
//                            Text('Neither', style: Theme.of(context).textTheme.display2),
                                ButtonTheme(
                                    minWidth: 0.0,
                                    child: FlatButton(
                                      onPressed: () { _handleMealTypeChange("Neither"); },
                                      padding: EdgeInsets.all(0),
                                      child: Text('Neither', style: Theme.of(context).textTheme.display2),
                                    )),
                              ],
                            )
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            child: Text('Location:',
                                style: Theme.of(context).textTheme.display1),
                          ),
                          //Dropdown for the location the meal has been eaten
                          Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                              child:DropdownButton<String>(
                                value: _mealLocation,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: _iconSize,
                                elevation: _elevation,
                                underline: Container(height: _height,
                                  color: Theme.of(context).accentColor,),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _mealLocation = newValue;
                                  });
                                },
                                items: <String>['Commons', 'Knollcrest', 'Home', 'Other']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: Theme.of(context).textTheme.display2),
                                  );
                                }).toList(),
                              )
                          )
                        ]),
                        ///the button to submit the record of the eaten meal
                        Padding(padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                          child: Builder( // Note: be careful about this when refactoring. It was a bit weird to get it to work at all.
                            builder: (context) => RaisedButton(
                                child: Text('Submit', style: TextStyle( color: Theme.of(context).primaryColor)),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  _submitForm(context, _mealType, _mealLocation);
                                }),
                          ),
                        ),
                      ],
                    )
                )
            )
          ]),);
  }
}