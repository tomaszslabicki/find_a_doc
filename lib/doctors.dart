import 'package:flutter/material.dart';

// Firestore import
import 'package:cloud_firestore/cloud_firestore.dart';

// Project files import
import 'rdv.dart';


class Doctors extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DoctorsPage(title: 'Choix de docteur');
  }
}

class DoctorsPage extends StatefulWidget {
  DoctorsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('medecin').snapshots(includeMetadataChanges: false),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _buildList(context, snapshot.data.docs);
              }
        )
      )
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  _goToRdv(doctorArray){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Rdv(doctorArray)));
  }

  return Padding(
    key: ValueKey(record.nom),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Card(
        elevation: 50.0,
        color: Colors.teal[300],
        child: ListTile(
          title: Text(record.prenom + ' ' + record.nom.toUpperCase(), style: TextStyle(color: Colors.white)),
          trailing: Icon(Icons.person, color: Colors.white),
          onTap: () => _goToRdv([record.id, record.prenom, record.nom]),
        ),
      ),
    ),
  );
}


class Record {
  final int id;
  final String nom;
  final String prenom;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['nom'] != null),
        assert(map['prenom'] != null),
        id = map['id'],
        nom = map['nom'],
        prenom = map['prenom'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$prenom:$nom>";
}