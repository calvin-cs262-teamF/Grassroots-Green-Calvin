import 'package:flutter/material.dart';

class Settings extends StatelessWidget {

  //Routename used for Navigation
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
    );
  }
}