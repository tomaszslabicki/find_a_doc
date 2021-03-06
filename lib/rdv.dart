import 'dart:convert';

import 'package:flutter/material.dart';

// Firestore import
import 'package:cloud_firestore/cloud_firestore.dart';

// Project files import
import 'patient.dart';

class Rdv extends StatelessWidget {
  List<String> doctor;

  Rdv(doctorArray){
    this.doctor = doctorArray;
  }

  @override
  Widget build(BuildContext context) {
    return _RdvPage(title: 'RDV ', doctor: doctor);
  }
}

class _RdvPage extends StatefulWidget {
  _RdvPage({Key key, this.title, this.doctor}) : super(key: key);

  final String title;
  final List<String> doctor;

  @override
  _RdvPageState createState() => _RdvPageState(doctor);
}

class _RdvPageState extends State<_RdvPage> {
  List<String> doctor;

  _RdvPageState(List<String>doctor){
    this.doctor = doctor;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                  child: Text(doctor[1] + ' ' + doctor[2])),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('rendezvous').snapshots(includeMetadataChanges: false),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _buildList(context, snapshot.data.docs);
                  }
                ),
              )
            ]
          )
        ),
      ),
    );
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

  Future<Map<String, dynamic>> patient = FirebaseFirestore.instance
      .collection('patient')
      .where(FieldPath(['id']), isEqualTo: record.idPatient)
      .get()
      .then((querySnapshot) {
        Map<String, dynamic> patient = querySnapshot.docs.single.data();
        return patient;
      });

  _rdvDetails(){
    //
  }

  _formatDate(){
    String day = record.dateH.toDate().day.toString();
    if (day.length == 1){day = "0" + day;}
    String month = record.dateH.toDate().month.toString();
    if (month.length == 1){month = "0" + month;}
    String year = record.dateH.toDate().year.toString();
    String hour = record.dateH.toDate().hour.toString();
    if (hour.length == 1){hour = "0" + hour;}
    String minute = record.dateH.toDate().minute.toString();
    if (minute.length == 1){minute = "0" + minute;}
    String dateTime = day + '/' + month + '/' + year + '   ' + hour + ':' + minute;
    return dateTime;
  }


  return Padding(
    key: ValueKey(record.id),
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
          title: patient == null
              ? LinearProgressIndicator()
              : FutureBuilder(
              future: patient,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Text(_formatDate(), style: TextStyle(color: Colors.white));
                } else if(snapshot.hasError) {
                  return Text('RDV error: ${snapshot.error.toString()}');
                } else {
                  return CircularProgressIndicator();
                }
              }),
          trailing: Text('RDV', style: TextStyle(color: Colors.white)),
          onTap: () => _rdvDetails(),
        ),
      ),
    ),
  );
}

class Record {
  final int id;
  final Timestamp dateH;
  final String commentaire;
  final int idMedecin;
  final int idPatient;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : /*assert(map['id'] != null),*/assert(map['dateH'] != null),
        assert(map['commentaire'] != null),
        assert(map['idMedecin'] != null),
        assert(map['idPatient'] != null),
        id = map['id'],
        dateH = map['dateH'],
        commentaire = map['commentaire'],
        idMedecin = map['idMedecin'],
        idPatient = map['idPatient'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

}
