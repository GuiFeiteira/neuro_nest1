class Medication {
  final String id;
  String name;
  String dosage;
  String frequency;
  String? notes;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.notes,
  });
}
