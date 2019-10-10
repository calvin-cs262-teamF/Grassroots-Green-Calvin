import 'package:flutter/material.dart';

class Goals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your Goal Progress')),
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



  void _setOverallProg() {
    setState(() {
      _progressImage = 'assets/goal_progress/overall_prog.png';
    });
  }
  void _setVegetarianProg() {
    setState(() {
      _progressImage = 'assets/goal_progress/vegetarian_prog.png';
    });
  }
  void _setVeganProg() {
    setState(() {
      _progressImage = 'assets/goal_progress/vegan_prog.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(_progressImage),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _setOverallProg,
                child: Text('Overall')
              ),
              RaisedButton(
                onPressed: _setVegetarianProg,
                child: Text('Vegetarian')
              ),
              RaisedButton(
                onPressed: _setVeganProg,
                child: Text('Vegan')
              ),
            ],
          )
        ],
      )
    );
  }
}
