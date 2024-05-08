import 'medication.dart';

class User {
  final String id; // Unique identifier for the user
  String name; // User's name
  int age; // User's age
  List<Medication> medications; // List of user's medications


  User({
    required this.id,
    required this.name,
    required this.age,
    this.medications = const [],

  });

  // Methods to add, remove, and update user data
  void addMedication(Medication medication) {
    medications.add(medication);
  }

  void removeMedication(String medicationId) {
    medications.removeWhere((medication) => medication.id == medicationId);
  }

  void updateMedication(String medicationId, Medication updatedMedication) {
    final index = medications.indexWhere((medication) => medication.id == medicationId);
    if (index != -1) {
      medications[index] = updatedMedication;
    }
  }




}
