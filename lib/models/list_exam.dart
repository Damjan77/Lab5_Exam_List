import 'Location.dart';

class ListExam {
  final String id;
  final String subject;
  //final String dataAndTime;
  final DateTime dateTime;
  final Location location;

  ListExam({
    required this.id,
    required this.subject,
    required this.dateTime,
    required this.location,
  });
}
