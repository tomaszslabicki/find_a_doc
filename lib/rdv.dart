import 'package:flutter/material.dart';
import 'calendar.dart';
import 'dart:async';

// Firestore import
import 'package:cloud_firestore/cloud_firestore.dart';

class Rdv extends StatelessWidget {
  List<dynamic> doctor;

  Rdv(doctorArray) {
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
  final List<dynamic> doctor;

  @override
  _RdvPageState createState() => _RdvPageState(doctor);
}

class _RdvPageState extends State<_RdvPage> {
  List<dynamic> doctor;
  bool calendarModeSwitch = false;
  DateTime day;
  DateTime dateChoice;

  _RdvPageState(List<dynamic> doctor) {
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
            child: Column(children: <Widget>[
              Container(child:
                Text(
                  'Dr ' + doctor[1] + ' ' + doctor[2].toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)
                ),
                padding: EdgeInsets.all(15.0)
              ),
              Container(
                child: RaisedButton(
                  color: Colors.teal,
                  elevation: 20.0,
                  onPressed: _toCalendar()
                )
              ),
              _simpleRdvList()
            ]
          )
        ),
      ),
    );
  }

  _toCalendar(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Calendar()));
  }

  _simpleRdvList(){
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rendezvous')
              .where(FieldPath(['idMedecin']), isEqualTo: doctor[0])
              .snapshots(includeMetadataChanges: false),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return _buildList(context, snapshot.data.docs);
          }),
    );
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

    _rdvDetails(String date, String prenom, String nom, String commentaire) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext buildContext) {
            return new SimpleDialog(
              backgroundColor: Colors.teal[600],
              elevation: 20.0,
              contentPadding: EdgeInsets.all(10.0),
              title: Text(date, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              children: [Column(
                  children: [
                    Text('Patient : \n' + prenom + '\n' + nom.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    Container(height: 10),
                    Container(height: 10),
                    Text('Commentaire : ' + commentaire, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                    Container(height: 20),
                    IconButton(
                        icon: Icon(Icons.keyboard_return_sharp, color: Colors.white,),
                        onPressed: () => Navigator.pop(context)
                    )
                  ],
                ),
              ],
            );
          });
    }

    _formatDate() {
      String day = record.dateH.toDate().day.toString();
      if (day.length == 1) {
        day = "0" + day;
      }
      String month = record.dateH.toDate().month.toString();
      if (month.length == 1) {
        month = "0" + month;
      }
      String year = record.dateH.toDate().year.toString();
      String hour = record.dateH.toDate().hour.toString();
      if (hour.length == 1) {
        hour = "0" + hour;
      }
      String minute = record.dateH.toDate().minute.toString();
      if (minute.length == 1) {
        minute = "0" + minute;
      }
      String dateTime =
          day + '/' + month + '/' + year + '   ' + hour + ':' + minute;
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
                child: patient == null
                    ? LinearProgressIndicator()
                    : FutureBuilder(
                        future: patient,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                                onTap: () => _rdvDetails(
                                    _formatDate(),
                                    snapshot.data['prenom'].toString(),
                                    snapshot.data['nom'].toString(),
                                    record.commentaire),
                                child: ListTile(
                                  title: Text(_formatDate(), style: TextStyle(color: Colors.white)),
                                  trailing: Text('RDV', style: TextStyle(color: Colors.white)),
                                  onTap: () => _rdvDetails(
                                      _formatDate(),
                                      snapshot.data['prenom'].toString(),
                                      snapshot.data['nom'].toString(),
                                      record.commentaire),
                                ));
                          } else if (snapshot.hasError) {
                            return Text(
                                'RDV error: ${snapshot.error.toString()}');
                          } else {
                            return CircularProgressIndicator();
                         }
                        }
                    )
            )
        )
    );
  }
}


class Record {
  final int id;
  final Timestamp dateH;
  final String commentaire;
  final int idMedecin;
  final int idPatient;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['dateH'] != null),
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
