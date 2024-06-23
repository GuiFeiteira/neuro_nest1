class Medication {
  final String id;
  String name;
  final String time;
  final List<String> days;
  bool isTaken;

  Medication({
    required this.id,
    required this.name,
    required this.days,
    required this.time,
    this.isTaken = false,
  });
}
