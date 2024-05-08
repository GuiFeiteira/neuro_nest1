class Medication {
  final String id; // Unique identifier for the medication
  String name; // Medication name
  String dosage; // Medication dosage
  String frequency; // Medication frequency (e.g., daily, twice a day)
  String? notes; // Optional notes about the medication

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.notes,
  });
}
