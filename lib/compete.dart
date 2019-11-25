/*  compete.dart
*
* A class used to display inter-dorm competition data to users
*
*/
import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:grassroots_green/compete/groupList.dart';

class Compete extends StatelessWidget {
  Compete({this.auth});

  final BaseAuth auth;
  static const String routeName = "/compete";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Compete',
        style: TextStyle(color: Theme.of(context).primaryColor,),),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
      ),
      body: GroupListStatefulWidget(),// CompetePage(auth: auth),
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
