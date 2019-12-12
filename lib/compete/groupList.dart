/*  groupList.dart
*
* A class used to display Compete groups
*
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/compete/group.dart';
import 'package:grassroots_green/util.dart';

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
      stream: Firestore.instance.collection('groups').snapshots(),
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
          ),
          child: ListTile(
            title: Text(record.name),
            trailing: Text("%"),
            onTap: () { _showGroupListPage(record); },
          )
      ),
    );
  }

  void _showGroupListPage(GroupDoc doc) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => GroupListSubPage(doc: doc)));
  }
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
              Text(doc.name, style: Theme.of(context).textTheme.title),
            StreamBuilder<QuerySnapshot>(
              stream: doc.members.snapshots(),
              builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              if (snapshot.hasError) return ListView(shrinkWrap: true);
              return _buildList(context, snapshot.data.documents);
            },
          ),
            ],
          )
      ),
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

    return Padding(
      key: ValueKey(data['ref']),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(data['name']),
            trailing: FutureBuilder<double>(
              future: getUserPlantPercent(data['ref'].documentID, 'Month'),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                String text = "";
                if(snapshot.hasData) {
                  text = (snapshot.data*100).round().toString() + '%';
                }
                return Text(text);
              },
            ),
          )
      ),
    );
  }

}
