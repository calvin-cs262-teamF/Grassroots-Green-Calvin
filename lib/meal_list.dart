import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:grassroots_green/meal_edit.dart';

class MealList extends StatefulWidget {
  static const String routeName = "/mealList";

  final BaseAuth auth;

  MealList({Key key, this.auth}) : super(key: key);

  @override
  _MealListState createState() => _MealListState(auth: auth);
}

class _MealListState extends State<MealList> {

  @override
  void initState() {
    super.initState();
  }

  /// Authenticator with user information.
  final BaseAuth auth;

  _MealListState({this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Meals',
        style: TextStyle(color: Theme.of(context).primaryColor,),),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
      ),

    body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<String>(
      future: auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data == null) { return ListView(); }
        return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').document(snapshot.data).collection('meals').orderBy("time", descending: true).limit(10).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              if (snapshot.hasError) return ListView();
              return _buildList(context, snapshot.data.documents);
            }
        );
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.reference),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: getNameText(record),
          trailing: Text(record.type),
          onTap: () { _showDialog(record); })// { _showDialog(record); })
        ),
      );
  }

  List<String> countries = <String>['Belgium','France','Italy','Germany','Spain','Portugal'];
  List<String> types = <String>["Vegetarian", "Vegan", "Neither"];
  List<String> locations = <String>['Commons', 'Knollcrest', 'Home', 'Other'];
  _showDialog(Record record) async{
    await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return new MealEditor(record: record);
//        return new AlertDialog(
//          title: new Text('Edit meal'),
//          actions: <Widget>[
//            new FlatButton(
//              onPressed: (){Navigator.of(context).pop('Cancel');},
//              child: new Text('Cancel'),
//            ),
//            new FlatButton(
//              onPressed: (){Navigator.of(context).pop('Accept');},
//              child: new Text('Save'),
//            ),
//          ],
//          content: new SingleChildScrollView(
//            child: new Material(
//              child: new MealEditor(record: record),
//            ),
//          ),
//        );
      },
      barrierDismissible: true,
    );
  }


  Widget getNameText(Record record) {
    return FutureBuilder<String>(
      future: getText(record),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
          return Text(record.reference.toString());
        }
        return Text('${snapshot.data}');
      },
    );
  }

  Future<String> getText(Record record) async {
    var formatter = new DateFormat('MMM d, yyyy');
    String formatted = formatter.format(record.time);
    return "$formatted: ${record.location}";
  }

}
