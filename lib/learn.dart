/*  learn.dart
*
* A class used to display LEARN content
*
*/
import 'package:flutter/material.dart';

class Learn extends StatelessWidget {

  //Routename used for Navigation
  static const String routeName = "/learn";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learn')),
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      new Text(" Here you can find information about Vegan and Vegitaran \n Eating and its environmental impact. \nGrassroots Green Maintains this site."),
  ],
      )
    ]));
  }
}
