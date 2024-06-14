class Medication {
  final String id;
  String name;
  final String time;
  final List<String> days;
  bool isTaken;
  //String dosage;
  //String frequency;
  String? notes;

  Medication({
    required this.id,
    required this.name,
    required this.days,
    //required this.dosage,
    //required this.frequency,
    required this.time,
    this.isTaken = false,
    this.notes,
  });
}
