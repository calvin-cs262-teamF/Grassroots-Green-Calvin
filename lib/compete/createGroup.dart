import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';

class CreateGroup extends StatelessWidget {

  CreateGroup({this.auth});

  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return CreateGroupStatefulWidget(auth: auth,);
  }

  }

class CreateGroupStatefulWidget extends StatefulWidget {

  final BaseAuth auth;

  CreateGroupStatefulWidget({Key key, this.auth}) : super(key: key);

  @override
  CreateGroupStatefulWidgetState createState() => CreateGroupStatefulWidgetState(auth: auth);
}

class CreateGroupStatefulWidgetState extends State<CreateGroupStatefulWidget> {

  CreateGroupStatefulWidgetState({this.auth});

  final BaseAuth auth;
  final _formKey = GlobalKey<FormState>();

  String _errorMessage;
  String groupName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Create a Group',
        style: TextStyle(color: Theme.of(context).primaryColor,),),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: new Form( key: _formKey, child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Group name:', style: Theme.of(context).textTheme.title,),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 20.0),
              child: new TextFormField(
                maxLines: 1,
                decoration: new InputDecoration(
                    hintText: 'name',
                    icon: new Icon(
                      Icons.group,
                      color: Colors.grey,
                    )
                ),
                validator: (value) => value.isEmpty || value.length < 3 ? "Group name must be at least 3 characters" : null,
                onSaved: (value) => groupName = value.trim(),
              )
          ),
          _showErrorMessage(),
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: new MaterialButton(
                elevation: 5.0,
                minWidth: 200.0,
                height: 42.0,
                color: Theme.of(context).buttonColor,
                child: new Text('Create Group', style: Theme.of(context).textTheme.button),
                onPressed: () {
                  _formKey.currentState.save();
                  bool error = _createGroup();
                  if(!error) {
                    Navigator.pop(context);
                  }
                },
              )
          ),
          // TODO: decide if we want to get any other information about the group
        ],
      ),),
    );
  }

  Widget _showErrorMessage() {
    if(_errorMessage != null) {
      return Text(_errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container();
    }
  }

  bool _createGroup() {
    // TODO: validate group name
    if(groupName == null || groupName.length < 2) {
      setState(() {
        _errorMessage = "Group name must be at least 2 characters";
        return true;
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
      auth.getCurrentUser().then((user) {
        Firestore.instance.collection('groups').document().setData({'name': groupName, 'admin': Firestore.instance.collection('users').document(user)});
      });
//        Firestore.instance.collection('groups').document().setData({'name': groupName, 'admin': Firestore.instance.collection('users').document(await auth.getCurrentUser())});
      return false;
    }
    return true;
  }

}

