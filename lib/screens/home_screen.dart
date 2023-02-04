import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3_exams_193222/models/Location.dart';
import 'package:lab3_exams_193222/screens/calendar_screen.dart';
import 'package:lab3_exams_193222/screens/google_map_screen.dart';
import 'package:lab3_exams_193222/screens/signin_screen.dart';
import 'package:intl/intl.dart';
import '../models/list_exam.dart';
import '../services/notifications.dart';
import '../widgets/NewExam.dart';

class HomeScreen extends StatefulWidget{
  static const String id = "mainScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotificationService service;

  @override
  void initState(){
    service = NotificationService();
    service.initialize();
    super.initState();
  }

  List<ListExam> exams = [
    ListExam(id: "D0", subject: "Strukturno programiranje", dateTime: DateTime.parse("2023-01-10 12:00:00"),location: Location(latitude: 42.0043165, longitude: 21.4096452)),
    ListExam(id: "D1", subject: "Bazi na podatoci", dateTime:  DateTime.parse("2023-01-11 13:30:00"),location: Location(latitude: 42.004400, longitude: 21.408918)),
    ListExam(id: "D2", subject: "Napredno programiranje", dateTime:  DateTime.parse("2023-01-12 13:00:00"),location: Location(latitude: 42.004906, longitude: 21.409890)),
  ];

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NewExam(_addNewExamToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewExamToList(ListExam item) {
    setState(() {
      exams.add(item);
    });
  }

  void _deleteExam(String id) {
    setState(() {
      exams.removeWhere((elem) => elem.id == id);
    });
  }

  // String _modifyDate(DateTime dateTime){
  //   String dateToString = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  //   List<String> date = dateToString.split(" ");
  //   String time = date[1].substring(0,5);
  //
  //   return date[0] + ' | ' + time + 'h';
  // }

  String _modifyDateAndLocation(DateTime date, Location location){
    String locationOfSubject = '';

    if(location.latitude == 42.004400 && location.longitude == 21.408918){
      locationOfSubject = "FEIT";
    }else if(location.latitude == 42.0043165 && location.longitude == 21.4096452){
      locationOfSubject = "FINKI";
    }else {
      locationOfSubject = "TMF";
    }

    String dateString = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    List<String> dateParts = dateString.split(" ");
    String modifiedTime = dateParts[1].substring(0,5);

    return dateParts[0] + ' | ' + modifiedTime + 'h | ' + locationOfSubject;
  }

  Future _signOut() async{
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        print("User signed out successfully!");
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    } on FirebaseAuthException catch (e){
      print("ERROR!");
      print(e.message);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Exams"),
        actions:[
          IconButton(
            icon: Icon(Icons.add_circle_rounded),
            onPressed: () => _addItemFunction(context),),
          ElevatedButton(
            child: Text("Sign out"),
            onPressed: _signOut,
          )
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: exams.isEmpty
                      ? Text("No exams!")
                      : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: exams.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                        child: ListTile(
                          tileColor: Colors.redAccent[100],
                          title: Text(
                            exams[index].subject ,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _modifyDateAndLocation(exams[index].dateTime, exams[index].location),
                            style: TextStyle(color: Colors.black),
                          ),

                          trailing: IconButton(
                              onPressed: () => _deleteExam(exams[index].id),
                              icon: Icon(Icons.delete_forever_rounded)),
                        ),
                      );
                    },
                  ),
                ),

                ElevatedButton.icon(
                  icon: Icon(Icons.calendar_month_outlined, size: 30,),
                  label: Text("Calendar", style: TextStyle(fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CalendarScreen(exams)));
                  },
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.map_outlined, size: 30,),
                    label: Text("Show Map", style: TextStyle(fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                    ),
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => GoogleMapPage(exams)));
                    },
                  ),
                ),
                 ElevatedButton.icon(
                   icon: Icon(Icons.notification_important_outlined, size: 30,),
                   label: Text("Press for Local Notification",
                     style: TextStyle(fontSize: 20),),

                   onPressed: () async {
                     await service.showNotification(id: 0,
                         title: 'You have upcoming exams',
                         body: 'Check your calendar');
                   },
                 ),
                 ElevatedButton.icon(
                   icon: Icon(Icons.notifications_paused_outlined, size: 30,),
                   label: Text(
                     "Schedule Notification", style: TextStyle(fontSize: 20),),
                   onPressed: () async {
                     //notification appears after 4 seconds
                     await service.showScheduledNotification(id: 0,
                         title: 'You have upcoming exams',
                         body: 'Check your calendar',
                         seconds: 4);
                   },
                 ),
              ],
            ),
          )
      )
    );
  }






}
