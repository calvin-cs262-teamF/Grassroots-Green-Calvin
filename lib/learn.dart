/*  learn.dart
*
* A class used to display LEARN content
*
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Learn extends StatelessWidget {
  /// RouteName used for Navigation
  static const String routeName = "/learn";

  /// Constructor for Eat.
  Learn();

  /// Builds the Eat page
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LearnStatefulWidget(),
    );
  }
}

class LearnStatefulWidget extends StatefulWidget {

  LearnStatefulWidget({Key key}) : super(key: key);

  @override
  LearnStatefulWidgetState createState() => LearnStatefulWidgetState();
}

class LearnStatefulWidgetState extends State<LearnStatefulWidget> {

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
    final LearnDoc record = LearnDoc.fromSnapshot(data);

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
              onTap: () { _showLearnPage(record); },
          )
      ),
    );
  }

  void _showLearnPage(LearnDoc doc) {
    //TODO: open the learn page
    assert(doc != null);
    Navigator.push(context, MaterialPageRoute(builder: (context) => LearnSubPage(doc: doc)));
  }
}

class LearnDoc {
  final String content;
  final String heading;
  final List sources;
  final String title;
  final List images;
  final DocumentReference reference;

  LearnDoc.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        assert(map['heading'] != null),
        assert(map['sources'] != null),
        assert(map['title'] != null),
        content = map['content'],
        heading = map['heading'],
        sources = map['sources'],
        title = map['title'],
        images = map['images'] == null ? new List(0) : map['images'];

  LearnDoc.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "LearnDoc<$title>";

}

class LearnSubPage extends StatelessWidget {
  final LearnDoc doc;

  LearnSubPage({this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LearnSubPageStatefulWidget(doc: doc),
    );
  }
}

class LearnSubPageStatefulWidget extends StatefulWidget {

  final LearnDoc doc;

  LearnSubPageStatefulWidget({Key key, this.doc}) : super(key: key);

  @override
  LearnSubPageStatefulWidgetState createState() => LearnSubPageStatefulWidgetState(doc: doc);
}

class LearnSubPageStatefulWidgetState extends State<LearnSubPageStatefulWidget> {

  final LearnDoc doc;

  LearnSubPageStatefulWidgetState({this.doc}) {
    assert(this.doc != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doc.title),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // TODO: use Theme data instead of hard-coded sizes
            Text(doc.heading, style: TextStyle(fontSize: 18, color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(doc.content, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text("Sources:", style: Theme.of(context).textTheme.title),
            _getSources(doc.sources),
          ],
        )
//          child: _getSources(doc.sources),
      ),
    );
  }

  Container _getSources(List sources) {
    List<Widget> text = [];
    sources.forEach( (src) {
      text.add(new Text(src));
      text.add(new Padding(
        padding: EdgeInsets.all(5),
      ));
    });
    return new Container(
      padding: EdgeInsets.all(10),
      child: new Column( children: text),
    );
  }
}
