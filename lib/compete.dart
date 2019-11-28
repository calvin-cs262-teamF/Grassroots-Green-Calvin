/*  compete.dart
*
* A class used to display inter-dorm competition data to users
*
*/
import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:grassroots_green/compete/groupList.dart';
import 'package:grassroots_green/compete/joinGroup.dart';
import 'package:grassroots_green/compete/createGroup.dart';

enum GroupAction { joinGroup, createGroup }

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
      floatingActionButton: FloatingActionButton(
        child: PopupMenuButton<GroupAction>(
          icon: Icon(Icons.more_horiz),
          onSelected: (GroupAction action) {
            if(action == GroupAction.createGroup) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup(auth: auth)));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => JoinGroup(auth: auth)));
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<GroupAction>>[
            const PopupMenuItem(child: Text("New group"), value: GroupAction.createGroup,),
            const PopupMenuItem(child: Text("Manage groups"), value: GroupAction.joinGroup,),
          ],
        )
      ),
      body: GroupListStatefulWidget(),
    );
  }

}
