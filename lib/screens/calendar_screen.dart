import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/list_exam.dart';

class CalendarScreen extends StatelessWidget{
  final List<ListExam> exams;
  static const String id = "calendarScreen";


  CalendarScreen(this.exams);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("CALENDAR"),
        ),
        body: Container(
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: MeetingDataSource(_getData(exams)),
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
            ),
            firstDayOfWeek: 1,
            showDatePickerButton: true,
          ),
        )
    );
  }
}

List<ListExam> _getData(List<ListExam> exams) {
  final List<ListExam> scheduledExams = exams;
  return scheduledExams;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<ListExam> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  DateTime getStartTime(int index){
    return appointments![index].date;
  }
  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

}