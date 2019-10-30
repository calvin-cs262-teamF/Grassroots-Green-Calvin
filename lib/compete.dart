import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Compete extends StatelessWidget {
  Compete({this.auth});

  final BaseAuth auth;
  static const String routeName = "/compete";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compete', style: TextStyle(color: Theme.of(context).primaryColor,),), backgroundColor: Theme.of(context).accentColor,),
      body: CompetePage(auth: auth),
    );
  }
}

class CompetePage extends StatefulWidget {
  final BaseAuth auth;

  CompetePage({Key key, this.auth}) : super(key: key);

  @override
  CompetePageState createState() => CompetePageState();
}

class CompetePageState extends State<CompetePage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Compete')
        ],
      ),
    );
  }
}
