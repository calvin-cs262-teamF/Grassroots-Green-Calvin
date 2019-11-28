import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDoc {

  final String name;
  final DocumentReference admin;
  final CollectionReference members;
  final DocumentReference reference;

  GroupDoc.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['admin'] != null),
        name = map['name'],
        admin = map['admin'],
        members = reference.collection('members').reference();

  GroupDoc.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "GroupDoc<$name>";

}
