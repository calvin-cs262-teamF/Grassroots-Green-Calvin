/*  main.dart
*
* The main dart file for the GrassRoots Green application. The entry point for
* the app is in this file. This project is a semester long project for CS 262
* Software Engineering at Calvin University with Professor Keith VanderLinden
*
* @author Elizabeth Koning
* @author Mason VanMeurs
* @author Nathan Meyer
* @author Lorrayya Williams
* @author Sam Tuit
*
* @since 2019-9-10
*
*/
import 'package:flutter/material.dart';
import 'package:grassroots_green/compete.dart';
import 'package:grassroots_green/eat.dart';
import 'package:grassroots_green/settings.dart';
import 'package:grassroots_green/login.dart';
import 'package:grassroots_green/auth.dart';
import 'package:grassroots_green/track.dart';
import 'package:grassroots_green/drawer.dart';
import 'package:grassroots_green/learn.dart';
import 'package:grassroots_green/meal_list.dart';

/// Runs the app.
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /// Widget that manages app information.

  /// Authenticator with information about authenticated user.
  final BaseAuth auth = new Auth();

  /// Gets the name of the Login route.
  static String getLoginRouteName() {
    return Login.routeName;
  }

  /// Gets the name of the Settings route.
  static String getSettingsRouteName() {
    return Settings.routeName;
  }

  /// Gets the name of the Compete route.
  static String getCompeteRouteName() {
    return Compete.routeName;
  }

  static String getMealListRouteName() {
    return MealList.routeName;
  }

  /// Returns widget for root of the app.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This declares all routes
      routes: <String, WidgetBuilder>{
        //Route declared for settings route
        Settings.routeName: (context) => Settings(auth:auth),
        Login.routeName: (context) => Login(auth: auth),
        Compete.routeName: (context) => Compete(auth: auth),
        MealList.routeName: (context) => MealList(auth: auth),
      },

      //When a route is generated, return the route to page,
      // which is set to the settings route
      onGenerateRoute: (RouteSettings settings) {
        var page;
        page = Settings();
        return MaterialPageRoute(builder: (context) => page);
      },

      title: 'Grassroots Green',

      //All theme data will be stored here
      theme: ThemeData(
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

          //this style is used for login text with firestore in the drawer
          caption: new TextStyle(fontSize: 20, color: Colors.white),

          //this style is used for regular bold text
          display1: new TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),

          //this style is used for regular text
          display2: new TextStyle(fontSize: 16, color: Colors.black),

          //this style is used for Drawer items
          display3: new TextStyle(fontSize: 16, color: Colors.black,),

          //this style is used for buttons in TRACK
          display4: new TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),

          //this style is being experimented with being used for the labels in settings
          body1: TextStyle(fontSize: 16, color: Colors.green[800], fontWeight: FontWeight.bold),

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
      ),
      // home: MyHomePage(title: 'Welcome to Grassroots Green!'),
      home: MyHomePage(auth: auth),
    );
  }
}

class MyHomePage extends StatefulWidget {
  /// Homepage Widget
  ///
  /// This widget is the homepage of the app, including the "EAT", "LEARN", and "TRACK" sub-pages
  /// the user can access the other pages from this page.

  MyHomePage({Key key, this.title, this.auth}) : super(key: key);

  /// Title displayed in header bar
  final String title;

  /// Information about authenticated user.
  final BaseAuth auth;

  @override
  _MyHomePageState createState() => _MyHomePageState(auth: auth);
}

class _MyHomePageState extends State<MyHomePage> {
  /// Homepage State
  ///
  /// This state contains information about the state of the app,
  /// including images and interactive features.

  /// Authenticator with user information.
  final BaseAuth auth;

  /// Home page sub-page selection. Defaults to EAT
  String _mainMenuOptions = "EAT";

  /// Creates a new _MyHomePageState object.
  _MyHomePageState({this.auth}) {
    auth.isSignedIn().then( (result) {
      if (!result) {
        Navigator.pushNamed(context, MyApp.getLoginRouteName());
      }
    });
  }

  /// Returns selected sub-page for display.
  StatelessWidget _getSubPage() {
    switch (_mainMenuOptions) {
      case 'EAT':{
        return Eat(auth: auth);
      }
      case 'LEARN':{
        return Learn.getLearn(context);
      }
      case 'TRACK':{
        return Track(auth: auth);
      }
      default:{
        return Eat(auth: auth);
      }
    }
  }

  /// Selects the EAT page for display.
  void _displayEat() {
    setState(() {
      _mainMenuOptions = "EAT";
    });
  }

  /// Selects the LEARN page for display.
  void _displayLearn() {
    setState(() {
      _mainMenuOptions = "LEARN";
    });
  }

  /// Selects the TRACK page for display.
  void _displayTrack() {
    setState(() {
      _mainMenuOptions = "TRACK";
    });
  }


  /// Builds the main page.
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            'Grassroots Green',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        drawer: GGDrawer.getDrawer(context, auth),
        body: Center(
            child: Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                          child: FlatButton(
                            padding: const EdgeInsets.all(18),
                            color: _mainMenuOptions == "EAT" ? Theme.of(context).buttonColor :Theme.of(context).accentColor,
                            onPressed: (){ _displayEat();},
                            child: new Text("EAT",
                                style: Theme.of(context).textTheme.button),
                          )
                      ),
                      Expanded(
                          child: FlatButton(
                            padding: const EdgeInsets.all(18),
                            color:_mainMenuOptions == "LEARN" ? Theme.of(context).buttonColor :Theme.of(context).accentColor,
                            onPressed: (){ _displayLearn();},
                            child: new Text("LEARN",
                                style: Theme.of(context).textTheme.button),
                          )
                      ),
                      Expanded(
                          child: FlatButton(
                            padding: const EdgeInsets.all(18),
                            color:_mainMenuOptions == "TRACK" ? Theme.of(context).buttonColor :Theme.of(context).accentColor,
                            onPressed: (){ _displayTrack();},
                            child: new Text("TRACK",
                                style: Theme.of(context).textTheme.button),
                          )
                      ),
                    ],
                  ),
                  _getSubPage(),
                ]
            )));
  }
}
