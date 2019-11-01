import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:grassroots_green/main.dart';

class GGDrawer {
  /// Returns the drawer of the main page for display.
  static Drawer getDrawer(BuildContext context, BaseAuth auth) {
    return new Drawer(
      // Using a ListView allows user to scroll through drawer options.
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .accentColor,
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
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .caption
                                );
                              case ConnectionState.waiting:
                                return new Text(
                                    'Awaiting result...',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .caption
                                );
                              default:
                                if (snapshot.hasError)
                                  return new Text(
                                      'Not signed in.',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption
                                  );
                                else if (snapshot.data == null ||
                                    snapshot.data == "")
                                  return new Text(
                                      'User',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption
                                  );
                                else
                                  return new Text(
                                      '${snapshot.data}',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption
                                  );
                            }
                          },
                        ),
                      ],
                    ))),
            ListTile(
              title: Text(
                  'Login',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display3
              ),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.pushNamed(context, MyApp.getLoginRouteName());
              },
            ),
            ListTile(
              title: Text(
                  'Logout',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display3
              ),
              onTap: () {
                auth.signOut();
                Navigator.pop(context); // close drawer
                Navigator.pushNamed(context, MyApp.getLoginRouteName());
              },
            ),
            ListTile(
              title: Text(
                  'Compete',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display3
              ),
              onTap: () {
                Navigator.pushNamed(context, MyApp.getCompeteRouteName());
              },
            ),
            ListTile(
              title: Text(
                  'Settings',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display3
              ),
              onTap: () {
                Navigator.pop(context); // close drawer
                //push the settings route to the Navigator
                Navigator.pushNamed(context, MyApp.getSettingsRouteName());
              },
            ),
          ],
        ));
  }
}