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

class MyHomePage extends StatefulWidget {
  /// Homepage Widget
  ///
  /// This widget is the homepage of the app, including the "EAT", "LEARN", and "TRACK" sub-pages
  /// the user can access the other pages from this page.

  MyHomePage({Key key, this.title, this.auth}) : super(key: key) {
  }

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

<<<<<<< HEAD
=======
  /// Returns the EAT column.
  Container displayEAT() {
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

  /// Scope of time series chart being displayed.
  String _scope = 'Week';

  /// This will set the time series chart in TRACK to 'week' scope
  void _setWeek() {
    _scope = 'Week';
    // TODO: Change the time series chart to this scope
  }
  /// This will set the time series chart in TRACK to 'month' scope
  void _setMonth() {
    _scope = 'Month';
    // TODO: Change the time series chart to this scope
  }

  /// Placeholder meal data for time series chart
  static final List<MealsByDate> placeholderVegetarian = [
    MealsByDate(DateTime(2019, 10, 26), 0),
    MealsByDate(DateTime(2019, 10, 27), 2),
    MealsByDate(DateTime(2019, 10, 28), 1),
    MealsByDate(DateTime(2019, 10, 29), 0),
    MealsByDate(DateTime(2019, 10, 30), 0),
    MealsByDate(DateTime(2019, 10, 31), 2),
    MealsByDate(DateTime(2019, 11, 1), 0),
  ];
  static final List<MealsByDate> placeholderVegan = [
    MealsByDate(DateTime(2019, 10, 26), 0),
    MealsByDate(DateTime(2019, 10, 27), 0),
    MealsByDate(DateTime(2019, 10, 28), 0),
    MealsByDate(DateTime(2019, 10, 29), 1),
    MealsByDate(DateTime(2019, 10, 30), 0),
    MealsByDate(DateTime(2019, 10, 31), 0),
    MealsByDate(DateTime(2019, 11, 1), 0),
  ];

  /// Series array in order to build time series chart
  static final List<charts.Series<MealsByDate, DateTime>> placeholderSeries = [
    charts.Series(
      id: 'Vegetarian',
      domainFn: (MealsByDate meals, _) => meals.date,
      measureFn: (MealsByDate meals, _) => meals.meals,
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      data: placeholderVegetarian,
    ),
    charts.Series(
      id: 'Vegan',
      domainFn: (MealsByDate meals, _) => meals.date,
      measureFn: (MealsByDate meals, _) => meals.meals,
      colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
      data: placeholderVegan,
    ),
  ];

  List<MealsByDate> getWeeksMeals(String type) {
    // TODO: return a list of meals from the past week
    // TODO: decide -- do we want this to be starting on the first day of the week and going forward, or should it be from exactly 7 days ago?

    // TODO: add error handling
    DateTime time = new DateTime.now().add( new Duration(days: -7) );
    List<DocumentSnapshot> mealDocs;
    List<MealsByDate> meals = [];

    auth.getCurrentUser().then( (user) => {
      Firestore.instance.collection('users').document(user).collection('meals').where('time', isGreaterThan: time).where('type', isEqualTo: type).getDocuments().then( (docs) => {
        mealDocs = docs.documents,
        mealDocs.forEach( (meal) => {
          meals.add( MealsByDate(meal.data['time'], meal.data['type']))
        })
      })
    });

    return meals;
//    List<DocumentSnapshot> docs = (await Firestore.instance.collection('users').document(await auth.getCurrentUser()).collection('meals').where('time', isGreaterThan: time).where('type', isEqualTo: type).getDocuments()).documents;
//    List<MealsByDate> meals = [];
//    docs.forEach( (doc) => {
//      // TODO: turn into a MealsByDate
//      // TODO: convert timestamp into a DateTime properly
//      meals.add( MealsByDate(doc.data['time'], doc.data['type'] ))
//    });
//    return meals;
  }

  Future<double> _getPlantPercent() async {
    DocumentSnapshot doc = await _getUserData();
    
    double percent = 0;
    int plantCount = 0, totalCount = 0;
    try {
      QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
          .document(await auth.getCurrentUser()).collection('meals')
          .getDocuments();
      List<DocumentSnapshot> meals = querySnapshot.documents;
      meals.forEach((meal) =>
      {
        if (meal.data['type'] == "Vegetarian" ||
            meal.data['type'] == "Vegan" ) {
          plantCount += 1
        },
        totalCount += 1
      });

      percent = plantCount / totalCount;
    } catch(e) {
      print("Not able to get track data properly"); // TODO: maybe add error display for user
    }

    return percent;
  }

  /// Returns the TRACK Column.
  Container displayTRACK() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            alignment: Alignment(0.0, 0.0),
            child: FutureBuilder<double>(
              future: _getPlantPercent(),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                double percent = 0;
                if ( !snapshot.hasError && snapshot.connectionState == ConnectionState.done ) {
                  percent = snapshot.data;
                }
                return CircularPercentIndicator(
                  radius: 180.0,
                  animation: true,
                  animationDuration: 1000,
                  lineWidth: 10.0,
                  percent: percent,
                  header: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      'Plant-Based Meals',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  center: Text(
                    (percent * 100).round().toString() + '%',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Theme.of(context).accentColor,
            );},),),

          Padding(  // time series chart for meals, by date
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              height: 200.0,
              child: MealsByDateChart(placeholderSeries),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _setWeek,
                  child: Text(
                      'Week',
                      style: Theme.of(context).textTheme.display4,
                  )
              ),
              FlatButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _setMonth,
                  child: Text(
                      'Month',
                      style: Theme.of(context).textTheme.display4,
                  )
              ),
            ],
          )
        ],
      ),
    );
  }

>>>>>>> WIP: getting meals list without Future
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
