import 'package:flutter/material.dart';
import 'package:grassroots_green/compete.dart';
import 'package:grassroots_green/settings.dart';
import 'package:grassroots_green/login.dart';
import 'package:grassroots_green/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final BaseAuth auth = new Auth();

  // This widget is the root of your application.
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
          display3: new TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)

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
  //Routename sed for Navigation
  //static const String routeName = "/";

  MyHomePage({Key key, this.title, this.auth}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final BaseAuth auth;

  @override
  _MyHomePageState createState() => _MyHomePageState(auth: auth);
}

class _MyHomePageState extends State<MyHomePage> {
  String _mealType = "NULL"; // TODO: set to user's default

  void _handleRadioValueChange1(String value) {
    setState(() {
      _mealType = value;
    });
  }

  String _progressImage = 'assets/goal_progress/overall_prog.png';
  String _chartImage = 'assets/goal_progress/overall_chart.png';
  String _scope = 'Overall';

  void _setOverall() {
    setState(() {
      _progressImage = 'assets/goal_progress/overall_prog.png';
      _chartImage = 'assets/goal_progress/overall_chart.png';
      _scope = 'Overall';
    });
  }
  void _setVegetarian() {
    setState(() {
      _progressImage = 'assets/goal_progress/vegetarian_prog.png';
      _chartImage = 'assets/goal_progress/vegetarian_chart.png';
      _scope = 'Vegetarian';
    });
  }
  void _setVegan() {
    setState(() {
      _progressImage = 'assets/goal_progress/vegan_prog.png';
      _chartImage = 'assets/goal_progress/vegan_chart.png';
      _scope = 'Vegan';
    });
  }

  static double _iconSize = 24;
  static int _elevation = 16;
  static double _height = 2;

  //Default values for Drop Downs
  String _mealLocation = 'Commons';

  //Default Home page option set to EAT
  String _mainMenuOptions = "EAT";

  void _SubmitForm(String type, String location) async {
    Firestore.instance.collection('users').document(await auth.getCurrentUser()).collection('meals').document().setData({'type': type, 'location': location, 'time': FieldValue.serverTimestamp()});
  }

  Column _testbuild() {
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

  Column displayEAT() {
    return Column(
      children: <Widget>[
        Text('Record a Meal:',
            style: Theme.of(context).textTheme.title),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                    value: "Vegetarian",
                    groupValue: _mealType,
                    onChanged: _handleRadioValueChange1),
                Text(
                  'Vegetarian',
                  style: Theme.of(context).textTheme.display2
                ),
                Radio(
                    value: "Vegan",
                    groupValue: _mealType,
                    onChanged: _handleRadioValueChange1),
                Text(
                  'Vegan',
                    style: Theme.of(context).textTheme.display2
                ),
                Radio(
                    value: "Neither",
                    groupValue: _mealType,
                    onChanged: _handleRadioValueChange1),
                Text(
                  'Neither',
                    style: Theme.of(context).textTheme.display2
                ),
              ],
            )),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Location:',
              style: Theme.of(context).textTheme.display1),

          //Dropdown for the location the meal has been eaten
          DropdownButton<String>(
            value: _mealLocation,
            icon: Icon(Icons.arrow_downward),
            iconSize: _iconSize,
            elevation: _elevation,
            underline: Container(
              height: _height,
              color: Theme.of(context).accentColor,
            ),
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
                    style: Theme.of(context).textTheme.display2
                ),
              );
            }).toList(),
          )
        ]),
        RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () {
            _SubmitForm(_mealType, _mealLocation);
          },
          child: Text('Submit',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ],
    );
  }

  Column displayLEARN() {
    return Column(
      children: <Widget>[
        Text('LEARN')
      ],
    );
  }

  Column displayTRACK() {
    return Column(
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
          margin: EdgeInsets.all(10.0),
          alignment: Alignment(0.0, 0.0),
          child: Text('Progress Towards Goal',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Image.asset(_progressImage),
        Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment(0.0, 0.0),
          child: Text('Meals by Day',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Image.asset(_chartImage),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: _setOverall,
                child: Text('Overall')
            ),
            RaisedButton(
                onPressed: _setVegetarian,
                child: Text('Vegetarian')
            ),
            RaisedButton(
                onPressed: _setVegan,
                child: Text('Vegan')
            ),
          ],
        )
      ],
    );
  }

  void _displayEat() {
    setState(() {
      _mainMenuOptions = "EAT";
    });
  }

  void _displayLearn() {
    setState(() {
      _mainMenuOptions = "LEARN";
    });
  }

  void _displayTrack() {
    setState(() {
      _mainMenuOptions = "TRACK";
    });
  }


  final BaseAuth auth;

  _MyHomePageState({this.auth}) {
    _getUserData().then( (data) { // TODO: make more error resistant
      setState(() {
        _mealLocation = data['defaultLocation'];
        _mealType = data['defaultMealType'];
      });
    });
  }

  Future<DocumentSnapshot> _getUserData() async {
    return Firestore.instance.collection('users').document(await auth.getCurrentUser()).get();
  }


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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          // widget.title resulted in errors on compile for some reason, so
          // title is hardcoded for now
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
              'Grassroots Green',
               style: TextStyle(
                   color: Theme.of(context).primaryColor,
              ),
          ),
        ),
        drawer: Drawer(
            // Now we add children to populate the Drawer

            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                    ),
                    child: Container(
                        child: Column(
                          children: <Widget>[
                            Material(
                                child: Image.asset(
                                    'assets/Grassroots_Green_Logo_16x9.PNG')),
                            new FutureBuilder<String>(
                              future: auth.getUserName(),
                              // a Future<String> or null
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return new Text(
                                        'Press button to start',
                                        style: Theme.of(context).textTheme.caption
                                    );
                                  case ConnectionState.waiting:
                                    return new Text(
                                        'Awaiting result...',
                                        style: Theme.of(context).textTheme.caption
                                    );
                                  default:
                                    if (snapshot.hasError)
                                      return new Text(
                                        'Not signed in.',
                                        style: Theme.of(context).textTheme.caption
                                      );
                                    else if (snapshot.data == null ||
                                        snapshot.data == "")
                                      return new Text(
                                        'User',
                                        style: Theme.of(context).textTheme.caption
                                      );
                                    else
                                      return new Text(
                                        '${snapshot.data}',
                                          style: Theme.of(context).textTheme.caption
                                      );
                                }
                              },
                            ),
                          ],
                        ))),
                ListTile(
                  title: Text(
                      'Login',
                      style: Theme.of(context).textTheme.display3
                  ),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, Login.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.display3
                  ),
                  onTap:() {
                    auth.signOut();
                    Navigator.pop(context); // close drawer
                    Navigator.pushNamed(context, Login.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                      'Compete',
                      style: Theme.of(context).textTheme.display3
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Compete.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.display3
                  ),
                  onTap: () {
                    //push the settings route to the Navigator
                    Navigator.pushNamed(context, Settings.routeName);
                  },
                ),
              ],
            )),
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
                  new Container(child: _testbuild(),)
                ]
            )));
  }
}
