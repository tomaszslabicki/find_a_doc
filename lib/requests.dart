import 'package:cloud_firestore/cloud_firestore.dart';

class Request {

  Request(){
    //
  }

  getAllDoctors() async {
    final snapshot = await FirebaseFirestore.instance.collection('medecin').get();
    print(snapshot.docs.map((doc) => doc.data()));
    return snapshot.docs.map((doc) => doc.data());
  }
/*
  getPatient(id){
    FirebaseFirestore.instance
        .collection('pa')
        .doc(1)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }*/
}