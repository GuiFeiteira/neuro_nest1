import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMedicationForm extends StatefulWidget {
  final Function(String, String) onSuccess; // Callback for successful addition

  const AddMedicationForm({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _AddMedicationFormState createState() => _AddMedicationFormState();
}

class _AddMedicationFormState extends State<AddMedicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _frequencyOptions = ['Diariamente', 'Duas Vezes ao Dia', 'Três Vezes ao Dia'];
  String? _selectedFrequency;
  List<TextEditingController> _timeControllers = [];

  List<Medication> _availableMedications = [
    Medication(name: 'Medication 1', time: '10:00 AM'),
    Medication(name: 'Medication 2', time: '12:00 PM'),
    Medication(name: 'GGMedication 1', time: '10:00 AM'),
    Medication(name: 'AMedication 2', time: '12:00 PM'),
    Medication(name: 'asdMedication 1', time: '10:00 AM'),
    Medication(name: 'pliMedication 2', time: '12:00 PM'),
    Medication(name: 'AVCAMedication 2', time: '12:00 PM'),
    Medication(name: 'aaEEasdMedication 1', time: '10:00 AM'),
    Medication(name: 'ApliMedication 2', time: '12:00 PM'),
  ];
  List<Medication> _filteredMedications = [];

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _timeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitMedication() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final frequency = _selectedFrequency!;
      final times = _timeControllers.map((controller) => controller.text).toList();

      try {
        // Pega o usuário atual
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Adiciona o medicamento no Firestore
          await FirebaseFirestore.instance.collection('medications').add({
            'user_id': user.uid,
            'name': name,
            'frequency': frequency,
            'times': times,
          });

          // Handle successful medication addition
          widget.onSuccess(name, frequency);

          // Clear form fields
          _nameController.clear();
          _selectedFrequency = null;
          _timeControllers.clear();
          _filteredMedications = _availableMedications;

          Navigator.pop(context);
        } else {
          // Handle user not logged in
          print('User is not logged in');
        }
      } catch (e) {
        // Handle errors (e.g., network issues)
        print('Error adding medication: $e');
      }
    }
  }

  void _filterMedications(String searchTerm) {
    _filteredMedications = _availableMedications.where((medication) =>
        medication.name.toLowerCase().startsWith(searchTerm.toLowerCase())).toList();
    setState(() {});
  }

  void _showTimePicker(int index) {
    BottomPicker.time(
      displayCloseIcon: false, // Hide close icon
      popOnClose: false,
      pickerTextStyle: TextStyle(fontSize: 18),
      pickerTitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Qual o horario de toma?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: CupertinoColors.systemTeal,
          ),
        ),
      ),
      onSubmit: (time) {
        setState(() {
          _timeControllers[index].text = DateFormat('HH:mm').format(time);
        });
      },
      onClose: () {},
      bottomPickerTheme: BottomPickerTheme.morningSalad,
      use24hFormat: true,
      initialTime: Time(minutes: 0, hours: 12),
    ).show(context);
  }

  void _updateTimeControllers() {
    int requiredControllers = 1;
    if (_selectedFrequency == 'Duas Vezes ao Dia') {
      requiredControllers = 2;
    } else if (_selectedFrequency == 'Três Vezes ao Dia') {
      requiredControllers = 3;
    }

    // Add or remove controllers to match the required number
    while (_timeControllers.length < requiredControllers) {
      _timeControllers.add(TextEditingController());
    }
    while (_timeControllers.length > requiredControllers) {
      _timeControllers.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 45),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Medicamento'),
              onChanged: (value) => _filterMedications(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Insira o nome do medicamento';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: _filteredMedications.isEmpty
                ? Text('')
                : ListView.builder(
              shrinkWrap: true, // Prevent list from expanding
              itemCount: _filteredMedications.length,
              itemBuilder: (context, index) {
                if (index < 3) {
                  final medication = _filteredMedications[index];
                  return ListTile(
                    tileColor: Colors.white,
                    title: Text(medication.name),
                    onTap: () {
                      _nameController.text = medication.name;
                      _selectedFrequency = null;
                      setState(() {
                        _filteredMedications.clear();
                      });
                    },
                  );
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFrequency,
              hint: Text('Frequência'),
              items: _frequencyOptions.map((value) => DropdownMenuItem(child: Text(value), value: value)).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFrequency = value;
                  _updateTimeControllers();
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione a frequência';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: List.generate(_timeControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timeControllers[index],
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Horário ${index + 1}',
                        ),
                        onTap: () => _showTimePicker(index),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione o horário ${index + 1}';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _showTimePicker(index),
                    ),
                  ],
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: _submitMedication,
            child: Text('Adicionar Medicamento'),
          ),
        ],
      ),
    );
  }
}

class Medication {
  final String name;
  final String time;

  Medication({required this.name, required this.time});
}
