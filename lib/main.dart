import 'package:flutter/material.dart';
import 'package:grassroots_green/settings.dart';
import 'package:grassroots_green/login.dart';
import 'package:grassroots_green/goals.dart';
import 'package:grassroots_green/auth.dart';

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
        Settings.routeName: (context) => Settings(),
        Login.routeName: (context) => Login(auth: auth),
      },

      //When a route is generated, return the route to page,
      // which is set to the settings route
      onGenerateRoute: (RouteSettings settings) {
        var page;
        page = Settings();
        return MaterialPageRoute(builder: (context) => page);
      },

      title: 'Grassroots Green',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted..
        primarySwatch: Colors.green,
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

  _MyHomePageState({this.auth});

  final BaseAuth auth;

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
        title: Text('Grassroots Green'),
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
                color: Colors.green,
              ),
                child: Container(
                    child: Column(
                      children: <Widget>[
                        Material(
                          child: Image.asset('assets/Grassroots_Green_Logo_16x9.PNG')
                        ),
                        new FutureBuilder<String>(
                          future: auth.getUserName(), // a Future<String> or null
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none: return new Text('Press button to start');
                              case ConnectionState.waiting: return new Text('Awaiting result...');
                              default:
                                if (snapshot.hasError)
                                  return new Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white, fontSize: 30),);
                                else if (snapshot.data == null || snapshot.data == "")
                                  return new Text('User', style: TextStyle(color: Colors.white, fontSize: 30),);
                                else
                                  return new Text('${snapshot.data}', style: TextStyle(color: Colors.white, fontSize: 30),);
                            }
                          },

                        ),
                      ],
                    )
                )
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Goal Progress'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext context) => new GoalsPage())
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                //push the settings route to the Navigator
                Navigator.pushNamed(context, Settings.routeName);
              },
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, Login.routeName);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap:() {
                auth.signOut();
                Navigator.pushNamed(context, Login.routeName);
              },
            ),
          ],
        )
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
