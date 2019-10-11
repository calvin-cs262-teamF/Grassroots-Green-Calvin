/// Placeholder page for goal tracking with static images

import 'package:flutter/material.dart';

class Goals extends StatelessWidget {
  static const String routeName = "/goals";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Weekly Goal Progress')),
      body: GoalsPage(),
    );
  }
}

class GoalsPage extends StatefulWidget {
  @override
  GoalsPageState createState() => GoalsPageState();
}

class GoalsPageState extends State<GoalsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Center(
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
      ),
    );
  }
}