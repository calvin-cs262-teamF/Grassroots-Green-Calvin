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
import 'package:grassroots_green/settings.dart';
import 'package:grassroots_green/login.dart';
import 'package:grassroots_green/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/drawer.dart';
import 'package:grassroots_green/learn.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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



//This class allows for text to become hyperlink
//It was taken from https://dev.to/guimg/hyperlink-widget-on-flutter-4fa5
class Hyperlink extends StatelessWidget {
  final String _url;
  final String _text;

  Hyperlink(this._url, this._text);

  _launchURL() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        _text,
        style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      ),
      onTap: _launchURL,
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


  /// Type of meal selected with radio button for meal submission.
  String _mealType = "NULL";
  /// Location of meal submitted by user.
  String _mealLocation = 'Commons';
  /// Home page sub-page selection. Defaults to EAT
  String _mainMenuOptions = "EAT";

  /// Size of icons on page
  static double _iconSize = 24;
  /// Elevation for dropdown buttons
  static int _elevation = 16;
  /// Height of buttons.
  static double _height = 2;

  /// Creates a new _MyHomePageState object.
  _MyHomePageState({this.auth}) {
    _loadSettings();
  }

  /// Modifies the meal type when value is changed by user.
  void _handleMealTypeChange(String value) {
    setState(() {
      _mealType = value;
    });
  }

  /// Location of goal progress image. (Temporary)
  String _progressImage = 'assets/goal_progress/overall_prog.png';
  /// Location of goal progress chart image. (Temporary)
  String _chartImage = 'assets/goal_progress/overall_chart.png';
  /// Type of goal charts being displayed.
  String _scope = 'Overall';

  /// Sets goal scope to show all meals.
  void _setOverall() {
    setState(() {
      _progressImage = 'assets/goal_progress/overall_prog.png';
      _chartImage = 'assets/goal_progress/overall_chart.png';
      _scope = 'Overall';
    });
  }

  /// Sets goal scope to show only vegetarian meals.
  void _setVegetarian() {
    setState(() {
      _progressImage = 'assets/goal_progress/vegetarian_prog.png';
      _chartImage = 'assets/goal_progress/vegetarian_chart.png';
      _scope = 'Vegetarian';
    });
  }

  /// Sets goal scope to show only vegan meals.
  void _setVegan() {
    setState(() {
      _progressImage = 'assets/goal_progress/vegan_prog.png';
      _chartImage = 'assets/goal_progress/vegan_chart.png';
      _scope = 'Vegan';
    });
  }

  /// Submit form and save to database.
  void _submitForm(String type, String location) async {
    Firestore.instance.collection('users').document(await auth.getCurrentUser()).collection('meals').document().setData({'type': type, 'location': location, 'time': FieldValue.serverTimestamp()});
  }

  /// Returns selected sub-page for display.
  Container _getSubPage() {
    switch (_mainMenuOptions) {
      case 'EAT':{
        return displayEAT();
      }
      case 'LEARN':{
        return displayLEARN();
      }
      case 'TRACK':{
        return displayTRACK();
      }
      default:{
        return displayEAT();
      }
    }
  }

  /// Returns the EAT column.
  Container displayEAT() {
    return Container(
        child: Padding(
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
                            Text('Vegetarian',
                                style: Theme.of(context).textTheme.display2),
                            Radio(value: "Vegan",
                                groupValue: _mealType,
                                onChanged: _handleMealTypeChange),
                            Text('Vegan',
                                style: Theme.of(context).textTheme.display2),
                            Radio(value: "Neither",
                                groupValue: _mealType,
                                onChanged: _handleMealTypeChange),
                            Text('Neither',
                                style: Theme.of(context).textTheme.display2),
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
                        child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () { _submitForm(_mealType, _mealLocation); },
                            child: Text('Submit',
                              style: TextStyle( color: Theme.of(context).primaryColor, ),
                            )
                        )
                    )
                  ],
                )
            )
        )
    );
  }

  /// Returns the LEARN Column.
  Container displayLEARN() {
      return Container(
        child: Column(
          children:<Widget> [
          //Image.asset('assets/learn_bakcground/grass.JPEG'),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      width: 400,
                      color: Colors.green,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(vertical: 16),
                        child: Hyperlink('https://navs-online.org/articles/veganism-animal-rights/', 'Animal Rights')
                    ),
                  ]
              )),
          Column(
              children: <Widget>[
                Container(
                  height: 90,
                  width:400,
                  color: Colors.green,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Hyperlink('https://www.globalchange.gov/climate-change', 'Climate Change')),
              ]
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      width: 400,
                      color: Colors.green,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Hyperlink('http://eices.columbia.edu/2018/08/16/veganism-and-sustainability/', 'Sustainability')
                    ),
                  ]
              )),
          Column(
              children: <Widget>[
                Container(
                  height: 90,
                  width: 400,
                  color: Colors.green,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Hyperlink('http://socialjusticestories.leadr.msu.edu/2016/03/19/human-rights-abuses-in-u-s-meat-packing-industry/', 'Workers\' Rights')
                ),
              ]
          ),

          Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      width: 400,
                      color: Colors.green,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Hyperlink('https://www.health.harvard.edu/staying-healthy/becoming-a-vegetarian','Health Benefits')
                    ),
                  ]
              )),
            //Image.asset('assets/Grassroots_Green_Logo_16x9.PNG'),
          ],),
        //Image.asset('assets/Grassroots_Green_Logo_16x9.PNG'),
      );
    }

  /// Returns the TRACK Column.
  //TODO We'll have to change the padding here once the graphs are being drawn dynamically and not just static images that get switched between each other
  Container displayTRACK() {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              alignment: Alignment(0.0, 0.0),
              child: Text(_scope,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0,),
              alignment: Alignment(0.0, 0.0),
              child: Text(
                'Progress Towards Goal',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Image.asset(_progressImage),
            Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment(0.0, 0.0),
              child: Text(
                'Meals by Day',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Image.asset(_chartImage),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: _setOverall,
                    child: Text(
                      'Overall',
                      style: Theme.of(context).textTheme.display4,
                    )
                ),
                RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: _setVegetarian,
                    child: Text(
                      'Vegetarian',
                      style: Theme.of(context).textTheme.display4,
                    )
                ),
                RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: _setVegan,
                    child: Text(
                      'Vegan',
                      style: Theme.of(context).textTheme.display4,
                    )
                ),
              ],
            )
          ],
        )
    );
  }

  /// Selects the EAT page for display.
  void _displayEat() {
    setState(() {
      _loadSettings(); // TODO: change to update as soon as settings are saved
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

  /// Loads default values from settings for EAT page.
  void _loadSettings() {
    _getUserData().then( (data) {
      setState(() {
        if(data != null && data.exists) {
          if(data['defaultLocation'] != null) {
            _mealLocation = data['defaultLocation'];
          }
          if(data['defaultMealType'] != null) {
            _mealType = data['defaultMealType'];
          }
        }
      });
    });
  }

  /// Gets user data from Firestore.
  Future<DocumentSnapshot> _getUserData() async {
    try {
      String user = await auth.getCurrentUser();
      return await Firestore.instance.collection('users').document(user).get();
    } catch(e) {
      return null;
    }
    //return Firestore.instance.collection('users').document(await auth.getCurrentUser()).get();
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
                  new Container(child: _getSubPage(),)
                ]
            )));
  }
}



