/*  drawer.dart
*
* Returns a drawer that is used for application navigation and to view user information
*
*/
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
                    )
                )
            ),
            ListTile(
              leading: Icon(Icons.star),
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
              leading: Icon(Icons.edit),
              title: Text(
                  'Edit Meals',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display3
              ),
              onTap: () {
                Navigator.pushNamed(context, MyApp.getMealListRouteName());
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                  'About',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display3
              ),
              onTap: () {
                Navigator.pop(context); // close drawer
                //push the settings route to the Navigator
                Navigator.pushNamed(context, MyApp.getAboutRouteName());
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(
                  'Help',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display3
              ),
              onTap: () {
                Navigator.pop(context); // close drawer
                //push the settings route to the Navigator
                Navigator.pushNamed(context, MyApp.getHelpRouteName());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                  'Preferences',
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
            getAccountOption(context, auth),
          ],
        ));
  }

  static Widget getAccountOption(BuildContext context, BaseAuth auth) {
    return FutureBuilder<String>(
      future: auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        bool loggedIn = snapshot.data != null;
        if(loggedIn) {
          return new ListTile(
            leading: Icon(Icons.exit_to_app),
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
              Navigator.pushReplacementNamed(context, MyApp.getLoginRouteName());
            },
          );
        } else {
          return new ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
                'Login',
                style: Theme
                    .of(context)
                    .textTheme
                    .display3
            ),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.pushReplacementNamed(context, MyApp.getLoginRouteName());
            },
          );
        }
      },
    );
  }
}
