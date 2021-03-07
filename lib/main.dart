import 'package:flutter/material.dart';

// Firebase import
import 'package:firebase_core/firebase_core.dart';

// Project files import
import 'package:find_a_doc/doctors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find a Doc',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Find a Doc'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  _doctorChoice(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/homePage.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: RaisedButton(
            onPressed: () => _doctorChoice(),
            elevation: 20.0,
            color: Colors.teal,
            textColor: Colors.green,
            child: Text(
              'Tous les RDV en 1 seul clic !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
