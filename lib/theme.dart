import 'package:flutter/material.dart';

ThemeData getTheme(bool dark) {
  if(dark) {
    return ThemeData(
      // This is the theme of your application.

      brightness: Brightness.dark,

      primaryColor: Colors.white,
      accentColor: Colors.green[700],
      buttonColor: Colors.green[900],

      fontFamily: 'Roboto',

      textTheme: TextTheme(

        //for some reason if I call Theme.of(context).accentColor for the text, it renders the 'EAT', 'LEARN', 'TRACK' text as gray
        //This style is for buttons on the homepage
        button: new TextStyle(fontSize: 22, color: Colors.white),

        //for some reason if I call Theme.of(context).primaryColor for the title, it renders the 'Record a Meal' text as blue
        title: new TextStyle(
            fontSize: 26, color: Colors.green, fontWeight: FontWeight.bold),

        //this style is used for login text with firestore in the drawer
        caption: new TextStyle(fontSize: 20, color: Colors.white),

        //this style is used for regular bold text
        display1: new TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),

        //this style is used for regular text
        display2: new TextStyle(fontSize: 16, color: Colors.white),

        //this style is used for Drawer items
        display3: new TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),

        //this style is used for buttons in TRACK
        display4: new TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),

        //this style is being experimented with being used for the labels in settings
        body1: TextStyle(fontSize: 16,
            color: Colors.green[800],
            fontWeight: FontWeight.bold),

        //this style is used for LEARN content to dynamically update with dark mode
        subhead: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),

        //All available theme values are listed below:
        //display4
        //display3
        //display2
        //display1
        //headline
        //title
        //subhead
        //body2
        //body1
        //caption
        //button

      ),
    );
  } else {
    return ThemeData(
      // This is the theme of your application.

      primaryColor: Colors.white,
      accentColor: Colors.green,
      buttonColor: Colors.green[800],

      fontFamily: 'Roboto',

      textTheme: TextTheme(

        //for some reason if I call Theme.of(context).accentColor for the text, it renders the 'EAT', 'LEARN', 'TRACK' text as gray
        //This style is for buttons on the homepage
        button: new TextStyle(fontSize: 22, color: Colors.white),

        //for some reason if I call Theme.of(context).primaryColor for the title, it renders the 'Record a Meal' text as blue
        title: new TextStyle(fontSize: 26, color: Colors.green, fontWeight: FontWeight.bold),

        //this style is used for login text with Firestore in the drawer
        caption: new TextStyle(fontSize: 20, color: Colors.white),

        //this style is used for regular bold text
        display1: new TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),

        //this style is used for regular text
        display2: new TextStyle(fontSize: 16, color: Colors.black),

        //this style is used for Drawer items
        display3: new TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),

        //this style is used for buttons in TRACK
        display4: new TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),

        //this style is being experimented with being used for the labels in settings
        body1: TextStyle(fontSize: 16, color: Colors.green[800], fontWeight: FontWeight.bold),

        //this style is used for LEARN content to dynamically update with dark mode
        subhead: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),

        //All available theme values are listed below:
        //display4
        //display3
        //display2
        //display1
        //headline
        //title
        //subhead
        //body2
        //body1
        //caption
        //button

      ),
    );
  }

}