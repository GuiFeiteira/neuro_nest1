import 'medication.dart';

class User {
  final String id;
  String name;
  int age;
  List<Medication> medications;


  User({
    required this.id,
    required this.name,
    required this.age,
    this.medications = const [],

  });

}
