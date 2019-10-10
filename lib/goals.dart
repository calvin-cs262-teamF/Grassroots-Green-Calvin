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
  String _progress_image = 'assets/goal_progress/overall_prog.png';

  void _vegetarian_prog() {
    setState(() {
      _progress_image = 'assets/goal_progress/vegetarian_prog.png';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset(_progress_image),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: null,
                child: Text('Overall')
              ),
              RaisedButton(
                onPressed: _vegetarian_prog,
                child: Text('Vegetarian')
              ),
              RaisedButton(
                onPressed: null,
                child: Text('Vegan')
              ),
            ],
          )
        ],
      )
    );
  }
}
