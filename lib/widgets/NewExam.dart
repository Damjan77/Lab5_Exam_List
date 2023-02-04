import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:lab3_exams_193222/models/list_exam.dart';
import 'package:flutter/widgets.dart';
import 'package:lab3_exams_193222/models/Location.dart';

class NewExam extends StatefulWidget {
  final Function addExam;

  NewExam(this.addExam);

  @override
  State<StatefulWidget> createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final _subjectController = TextEditingController();
  final _dataAndTimeController = TextEditingController();

  String valueOfLocation = 'FINKI';
  late String subject;
  late String dataAndTime;
  late Location location;

  void _submitData(BuildContext context) {

    final vnesensubject = _subjectController.text;
    final vnesenadataAndTime = _dataAndTimeController.text;
    //final vnesenalocation = _locationController.text;

    if (vnesensubject.isEmpty || vnesenadataAndTime.isEmpty) {
      return;
    }

    int date = '-'.allMatches(_dataAndTimeController.text).length; //should be 2
    int time = ':'.allMatches(_dataAndTimeController.text).length; //should be 1

    if(_dataAndTimeController.text.length < 16 || date != 2 || time != 1){
      print("Date is not in the right format!");
      return;
    }

    final String vnesenDate = _dataAndTimeController.text + ':00';
    DateTime dateTime = DateTime.parse(vnesenDate);

    if(valueOfLocation == "FINKI"){
      location = Location(latitude: 42.0043165, longitude: 21.4096452);
    }else if(valueOfLocation == "FEIT"){
      location = Location(latitude: 42.004400, longitude: 21.408918);
    }else {
      location = Location(latitude: 42.004906, longitude: 21.409890);
    }

    final newExam = ListExam(
        id: nanoid(5),
        subject: vnesensubject,
        dateTime: dateTime,
        location:location,
    );

    widget.addExam(newExam);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Subject name"),
              controller: _subjectController,
              // onSubmitted: (_) => _submitData(),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Date (ex. 2022-01-01 15:00)"),
              controller: _dataAndTimeController,
              // onSubmitted: (_) => _submitData(),
              textInputAction: TextInputAction.next,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text("Location", style: TextStyle(color: Colors.grey[600], fontSize: 15, ),),
                ),
                DropdownButton(
                    value: valueOfLocation,
                    items: <String>['FINKI', 'TMF', 'FEIT'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String> (
                        value: value,
                        child: Text(value, textAlign: TextAlign.center,),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        valueOfLocation = newValue!;
                      });
                      print("submitted");
                      _submitData(context);
                    }
                )
              ],
            )
          ],
        )
    );
  }
}
