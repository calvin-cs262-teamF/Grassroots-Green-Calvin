/*  about.dart
*
* A class used to display LEARN content
*
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/unicode.dart';

class About extends StatelessWidget {
  /// RouteName used for Navigation
  static const String routeName = "/about";

  /// Constructor for Eat.
  About();

  /// Builds the Eat page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text(
      'About',
      style: TextStyle(color: Theme.of(context).primaryColor,),),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor, //change your color here
      ),
    ),
      body: AboutStatefulWidget(),
    );
  }
}

class AboutStatefulWidget extends StatefulWidget {

  AboutStatefulWidget({Key key}) : super(key: key);

  @override
  AboutStatefulWidgetState createState() => AboutStatefulWidgetState();
}

class AboutStatefulWidgetState extends State<AboutStatefulWidget> {

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
      stream: Firestore.instance.collection('about').snapshots(),
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
    final AboutDoc record = AboutDoc.fromSnapshot(data);


    return Padding(
      key: ValueKey(record.reference),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: Column(
            children: <Widget> [
              Text(record.title1, style:  Theme.of(context).textTheme.title),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),),
              Text(record.body1,style:  Theme.of(context).textTheme.display1),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),),
              Text(record.title2, style:  Theme.of(context).textTheme.title),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),),
              Text(record.body2,  style:  Theme.of(context).textTheme.display1),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),),
              Text(record.contact,style:  Theme.of(context).textTheme.body1),

            ]
        ),),
    );
  }


}

class AboutDoc {
  final String body1;
  final String body2;
  final String title1;
  final String title2;
  final String contact;
  final DocumentReference reference;

  AboutDoc.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Body1'] != null),
        assert(map['Body2'] != null),
        assert(map['Title1'] != null),
        assert(map['Title2'] != null),
        assert(map['Contact'] != null),
        contact = map['Contact'],
        body1 = map['Body1'],
        body2 = map['Body2'],
        title1 = map['Title1'],
        title2 = map['Title2'];

  AboutDoc.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);



}

String parseContent(String original) {
  // TODO: change all of the characters in [] to be superscript
  String result = original;
  String regex = RegExp.escape("[") + "(.*?)" + RegExp.escape("]");
  result = result.replaceAllMapped(
      new RegExp(regex),
          (Match m) {
        print(m.group(0));
        String temp = "";
//            String temp = "${m.group(0).substring(1, m.group(0).length-1)}";
        for(int i = 1; i < m.group(0).length - 1; i++) {
          String char = m.group(0)[i];
          if (char == ",") char = '-';
          temp += unicode_map[char][0];
//              temp += m.group(0)[i];
        }
        return temp;
//            return "${m.group(0).substring(1, m.group(0).length-1)}";
      }
  );
//  result = result.replaceAll("[", '');
//  result = result.replaceAll("]", '');
  return result;
}

