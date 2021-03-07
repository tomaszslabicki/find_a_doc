/*import 'package:flutter/material.dart';
import 'rdv.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CalendarPage(title: "Calendar");
  }
}

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime dateChoice;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _rdvCalendarPicker();
    });
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
            child:
        )
      ),
    );
  }

  Future<Null> _rdvCalendarPicker() async {
    DateTime choice = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(new Duration(days: 30)),
        lastDate: DateTime.now().subtract(new Duration(days: -180))
    );
    if (choice != null){
      setState(() {
        dateChoice = choice;
      });
    }
  }

  _rdvCalendar() {
    var choice = _rdvCalendarPicker();
    return FutureBuilder(
        future: choice,
        builder: (context, snapshot){
          if (snapshot.hasData){
            return _calendarFutureBuilder(dateChoice);
          } else if (snapshot.hasError){
            return Text(snapshot.error.toString());
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }

  _calendarFutureBuilder(choice) {
    Future<Widget> myWidget;
    choice == null
        ? CircularProgressIndicator()
        : FutureBuilder<Widget>(
        future: myWidget,
        builder: (context, snapshot) {
          return Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('rendezvous')
                    .where(FieldPath(['dateH']), isGreaterThanOrEqualTo: DateTime(choice.year, choice.month, choice.day))
                    .where(FieldPath(['dateH']), isLessThan: DateTime(choice.year, choice.month, choice.day+1))
                    .snapshots(includeMetadataChanges: false),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return _buildListCalendar(context, snapshot.data.docs);
                }),
          );
        }
    );
  }
}
*/