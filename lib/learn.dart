import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:grassroots_green/main.dart';

class Learn {
  /// Returns a Container for the LEARN page
  static Container getLEARN(BuildContext context, BaseAuth auth) {
    return new Container(
        child: Column(
          children: <Widget>[
            Text('LEARN')
          ],
        )
    );
  }
}