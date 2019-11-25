/*  groupList.dart
*
* A class used to display Compete groups
*
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GroupList extends StatelessWidget {
  /// RouteName used for Navigation
//  static const String routeName = "/compete";

  /// Constructor for Eat.
  GroupList();

  /// Builds the Eat page
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GroupListStatefulWidget(),
    );
  }
}

class GroupListStatefulWidget extends StatefulWidget {

  GroupListStatefulWidget({Key key}) : super(key: key);

  @override
  GroupListStatefulWidgetState createState() => GroupListStatefulWidgetState();
}

class GroupListStatefulWidgetState extends State<GroupListStatefulWidget> {

  @override
  Widget build(BuildContext context) {
    return new Column (
        children: <Widget> [
          _buildBody(context),
        ]
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('info').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        if (snapshot.hasError) return ListView(shrinkWrap: true);
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      shrinkWrap: true,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final GroupDoc record = GroupDoc.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.reference),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).accentColor,
          ),
          child: ListTile(
            title: Text(record.name, style: Theme.of(context).textTheme.button),
            onTap: () { _showGroupListPage(record); },
          )
      ),
    );
  }

  void _showGroupListPage(GroupDoc doc) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => GroupListSubPage(doc: doc)));
  }
}

class GroupDoc {
  final String name;
  final String admin;
  final DocumentReference reference;

  GroupDoc.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['admin'] != null),
        name = map['name'],
        admin = map['admin'];

  GroupDoc.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "GroupDoc<$name>";

}

class GroupListSubPage extends StatelessWidget {
  final GroupDoc doc;

  GroupListSubPage({this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GroupListSubPageStatefulWidget(doc: doc),
    );
  }
}

class GroupListSubPageStatefulWidget extends StatefulWidget {

  final GroupDoc doc;

  GroupListSubPageStatefulWidget({Key key, this.doc}) : super(key: key);

  @override
  GroupListSubPageStatefulWidgetState createState() => GroupListSubPageStatefulWidgetState(doc: doc);
}

class GroupListSubPageStatefulWidgetState extends State<GroupListSubPageStatefulWidget> {

  final GroupDoc doc;

  GroupListSubPageStatefulWidgetState({this.doc}) {
    assert(this.doc != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doc.name),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
          margin: const EdgeInsets.all(15),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // TODO: use Theme data instead of hard-coded sizes
              Text(doc.name, style: TextStyle(fontSize: 18, color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold)),
            ],
          )
//          child: _getSources(doc.sources),
      ),
    );
  }
}
