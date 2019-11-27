/*  joinGroup.dart
*
* A class used to allow users to create and join groups
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grassroots_green/compete/groupList.dart';
import 'package:grassroots_green/auth.dart';

class JoinGroup extends StatelessWidget {

  JoinGroup({this.auth});

  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Manage Your Groups',
        style: TextStyle(color: Theme.of(context).primaryColor,),),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: JoinGroupStatefulWidget(auth: auth),
    );
  }
}

class JoinGroupStatefulWidget extends StatefulWidget {

  final BaseAuth auth;

  JoinGroupStatefulWidget({Key key, this.auth}) : super(key: key);

  @override
  JoinGroupStatefulWidgetState createState() => JoinGroupStatefulWidgetState(auth: auth);
}

class JoinGroupStatefulWidgetState extends State<JoinGroupStatefulWidget> {

  JoinGroupStatefulWidgetState({this.auth});

  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(snapshot.data == null) {
          return Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 20.0) ),
              Text("    Sign-in to join groups.",)
            ],
          );
        } else {
          return new Column (
              children: <Widget>[
                _buildBody(context),
              ]
          );
        }
      },
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
      children: snapshot.map((data) => _getListItem(context, data)).toList(),
      shrinkWrap: true,
    );
  }

  Widget _getListItem(BuildContext context, DocumentSnapshot data) {
    return FutureBuilder<Widget>(
      future: _buildListItem(context, data),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.data == null) { return LinearProgressIndicator(); }
        return snapshot.data;
      },
    );
  }

  Future<Widget> _buildListItem(BuildContext context, DocumentSnapshot data) async {
    final GroupDoc record = GroupDoc.fromSnapshot(data);
    DocumentReference user = Firestore.instance.collection('users').document(await auth.getCurrentUser());
    QuerySnapshot docs = await record.members.where('ref', isEqualTo: user).getDocuments();
    bool groupMember = docs.documents.length > 0;

    return Padding(
      key: ValueKey(record.reference),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
            color: groupMember ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
          ),
          child: ListTile(
            title: Text(record.name),
            onTap: () {
              _joinGroup(record, user, docs, groupMember);
            },
          )
      ),
    );
  }

  void _joinGroup(GroupDoc record, DocumentReference user, QuerySnapshot docs, bool groupMember) async {
    // TODO: make impossible for admin to leave the group
    String userName = await auth.getUserName();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String groupName = record.name;

        return new AlertDialog(
          title: new Text(groupMember
              ? "Leave group '$groupName'?"
              : "Join group '$groupName'?"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop('No');
                // Whether a member or not, do nothing
              },
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop('Yes');
                if(groupMember) {
                  // leave group
                  setState(() {
                    for(DocumentSnapshot doc in docs.documents) {
                      doc.reference.delete();
                    }
                  });
                } else {
                  // join group
                  setState(() {
                    record.members.document().setData( {'ref': user, 'name': userName} );
                  });
                }
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

}
