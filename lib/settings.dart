import 'package:flutter/material.dart';

class Settings extends StatelessWidget {

  //Routename used for Navigation
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
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

  //Static parameters for Drop Downs
  static double _iconSize = 24;
  static int _elevation = 16;
  static double _height = 2;

  //Default values for Drop Downs
  String emptyDropDownValue = '3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            //Meals a Day
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Meals per Day:'
                  ),
                  //Dropdown for how many meals per day
                  DropdownButton<String>(
                    value: emptyDropDownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: _iconSize,
                    elevation: _elevation,
                    underline: Container(
                      height: _height,
                      color: Colors.green,
                    ),
                    onChanged: (String newValue){
                      setState(() {
                        emptyDropDownValue = newValue;
                      });
                    },
                    items: <String>['1', '2', '3', '4', '5', '6']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  )
                ]
            ),
          ],
        ),
    );
  }
}