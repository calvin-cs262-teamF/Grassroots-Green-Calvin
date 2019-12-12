/*  help.dart
*
* A class used to display LEARN content
*
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/unicode.dart';

class Help extends StatelessWidget {
  /// RouteName used for Navigation
  static const String routeName = "/help";

  /// Constructor for Eat.
  Help();

  /// Builds the Eat page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Help',
        style: TextStyle(color: Theme.of(context).primaryColor,),),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
      ),
      body: HelpStatefulWidget(),
    );
  }
}

class HelpStatefulWidget extends StatefulWidget {

  HelpStatefulWidget({Key key}) : super(key: key);

  @override
  HelpStatefulWidgetState createState() => HelpStatefulWidgetState();
}

class HelpStatefulWidgetState extends State<HelpStatefulWidget> {

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
      stream: Firestore.instance.collection('help').snapshots(),
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
    final HelpDoc record = HelpDoc.fromSnapshot(data);

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
            title: Text(record.title, style: Theme.of(context).textTheme.button),
            onTap: () { _showHelpPage(record); },
          )
      ),
    );
  }

  void _showHelpPage(HelpDoc doc) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSubPage(doc: doc)));
  }
}

class HelpDoc {
  final String content;
  final String title;
  final DocumentReference reference;

  HelpDoc.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        assert(map['title'] != null),
        content = parseContent(map['content']),
        title = map['title'];


  HelpDoc.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}

String parseContent(String original) {
  String result = original;

  result = result.replaceAll(new RegExp(RegExp.escape(r'\n')), "\n");

  return result;
}

class HelpSubPage extends StatelessWidget {
  final HelpDoc doc;

  HelpSubPage({this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HelpSubPageStatefulWidget(doc: doc),
    );
  }
}

class HelpSubPageStatefulWidget extends StatefulWidget {

  final HelpDoc doc;

  HelpSubPageStatefulWidget({Key key, this.doc}) : super(key: key);

  @override
  HelpSubPageStatefulWidgetState createState() => HelpSubPageStatefulWidgetState(doc: doc);
}

class HelpSubPageStatefulWidgetState extends State<HelpSubPageStatefulWidget> {

  final HelpDoc doc;

  HelpSubPageStatefulWidgetState({this.doc}) {
    assert(this.doc != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doc.title,
            style: TextStyle(color: Colors.white,)
        ),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
      ),
      body: Container(
          margin: const EdgeInsets.all(15),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // TODO: use Theme data instead of hard-coded sizes
              Text(doc.content, style: Theme.of(context).textTheme.subhead),
              Padding(
                padding: EdgeInsets.all(10),
              ),

            ],
          )
//          child: _getSources(doc.sources),
      ),
    );
  }



}
