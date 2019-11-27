import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MealEditor extends StatefulWidget {
  MealEditor({
    Key key,
    this.record
  }): super(key: key);

//  final List<String> items;
  final Record record;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState(record: record);
}

class _MyDialogContentState extends State<MealEditor> {
  String _location;
  String _type;
  DateTime _time;
  Record record;

  _MyDialogContentState({this.record}) {
    _location = record.location;
    _type = record.type;
    _time = record.time;
  }

  @override
  void initState(){
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _time,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _time)
      setState(() {
        _time = picked;
      });
  }

  _getContent(){
    var formatter = new DateFormat('MMM d, yyyy');
    String formatted = formatter.format(_time);
    String date = "$formatted";

    return new Column(
        children: <Widget>[
          new Row(
              children: [
                Text("Location: "),
                DropdownButton<String>(
                value: _location,
                icon: Icon(Icons.arrow_drop_down),
//                iconSize: _iconSize,
//                elevation: _elevation,
                underline: Container(
                  color: Theme.of(context).accentColor,),
                onChanged: (String newValue) {
                  setState(() {
                    _location = newValue;
                  });
                },
                items: <String>['Commons', 'Knollcrest', 'Home', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: Theme.of(context).textTheme.display2),
                  );
                }).toList(),
              ),
              ]
          ),
          new Row( children: [
            Text("Type:        "),
            DropdownButton<String>(
                  value: _type,
                  icon: Icon(Icons.arrow_drop_down),
                  underline: Container(
                    color: Theme.of(context).accentColor,),
                  onChanged: (String newValue) {
                    setState(() {
                      _type = newValue;
                    });
                  },
                  items: <String>['Vegetarian', 'Vegan', 'Neither']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: Theme.of(context).textTheme.display2),
                    );
                  }).toList(),
                ),
          ]),
          new Row(
            children: [
              Text("Date:    "),
//              Text(date, style: Theme.of(context).textTheme.display1),
              FlatButton(
                child: Row( children: <Widget>[Text(date, style: Theme.of(context).textTheme.display2), Icon(Icons.arrow_drop_down)]),
                onPressed: () => {
                  setState(() {
                    _selectDate(context);
                  })
                },
              ),
            ]
          ),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Edit meal'),
      actions: <Widget>[
        new FlatButton(
          onPressed: (){
            Navigator.of(context).pop('Delete');
            record.reference.delete();
          },
          child: new Text('Delete', style: TextStyle(color: Colors.red),),
        ),
        new FlatButton(
          onPressed: (){Navigator.of(context).pop('Cancel');},
          child: new Text('Cancel'),
        ),
        new FlatButton(
          onPressed: (){
            Navigator.of(context).pop('Accept');
            record.reference.updateData({'location': _location, 'type': _type, 'time': _time});
            },
          child: new Text('Save'),
        ),
      ],
      content: new SingleChildScrollView(
        child: new Material(
          child: _getContent()
        ),
      ),
    );

//    return _getContent();
  }
}

class Record {
  final DateTime time;
  final String type;
  final String location;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        assert(map['time'] != null),
        assert(map['location'] != null),
        time = new DateTime.fromMillisecondsSinceEpoch(map['time'].millisecondsSinceEpoch),
        type = map['type'],
        location = map['location'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$type, $time, $location>";
}

