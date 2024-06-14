import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notifications/notification_controller.dart';

class AddMedicationForm extends StatefulWidget {
  final Function(String, String) onSuccess; // Callback for successful addition

  const AddMedicationForm({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _AddMedicationFormState createState() => _AddMedicationFormState();
}

class _AddMedicationFormState extends State<AddMedicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _frequencyOptions = ['Diariamente', 'Alguns Dias da Semana', 'As Needed'];
  final _timesPerDayOptions = ['Uma vez', 'Duas Vezes ao Dia', 'Três Vezes ao Dia'];
  String? _selectedFrequency;
  String? _selectedTimesPerDay;
  List<String> _selectedDays = [];
  List<TextEditingController> _timeControllers = [];
  bool _notify = false;

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
      if(frequency == 'Diariamente'){
        _selectedDays = ['Sunday ', 'Monday', 'Tuesday ', 'Wednesday ', 'Thursday ', 'Friday ', 'Saturday ' ];

      }

      try {

        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {

          await FirebaseFirestore.instance.collection('medications').add({
            'user_id': user.uid,
            'name': name,
            'frequency': frequency,
            'times': times,
            'days': _selectedDays,
          });

          // Handle successful medication addition
          widget.onSuccess(name, frequency);

          // Clear form fields
          _nameController.clear();
          _selectedFrequency = null;
          _selectedTimesPerDay = null;
          _timeControllers.clear();
          _filteredMedications = _availableMedications;
          _selectedDays.clear();

          Navigator.pop(context);


          if (_notify) {
            for (String time in times) {
              await NotificationController.scheduleNotification(name, time, frequency, daysOfWeek: _selectedDays);
            }
          }
        } else {
          // Handle user not logged in
          print('User is not logged in');
        }
      } catch (e) {

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
      displayCloseIcon: false,
      pickerTextStyle: TextStyle(fontSize: 18),
      pickerTitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Qual o horário de toma?',
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
    if (_selectedTimesPerDay == 'Duas Vezes ao Dia') {
      requiredControllers = 2;
    } else if (_selectedTimesPerDay == 'Três Vezes ao Dia') {
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

  Widget _buildDaysOfWeekSelector() {
    final daysOfWeek = ['Sunday ', 'Monday', 'Tuesday ', 'Wednesday ', 'Thursday ', 'Friday ', 'Saturday ' ];
    return Wrap(
      spacing: 5.0,
      children: daysOfWeek.map((day) {
        final isSelected = _selectedDays.contains(day);
        return ChoiceChip(
          label: Text(day),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedDays.add(day);
              } else {
                _selectedDays.remove(day);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  items: _frequencyOptions
                      .map((value) => DropdownMenuItem(child: Text(value), value: value))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value;
                      _selectedDays.clear();
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
              if (_selectedFrequency == 'Alguns Dias da Semana')
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selecione os dias da semana:'),
                      _buildDaysOfWeekSelector(),
                    ],
                  ),
                ),
              if (_selectedFrequency != null && _selectedFrequency != 'As Needed')
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedTimesPerDay,
                    hint: Text('Quantas vezes ao dia?'),
                    items: _timesPerDayOptions
                        .map((value) => DropdownMenuItem(child: Text(value), value: value))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTimesPerDay = value;
                        _updateTimeControllers();
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione quantas vezes ao dia';
                      }
                      return null;
                    },
                  ),
                ),
              SizedBox(height: 5),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _notify,
                      onChanged: (value) {
                        setState(() {
                          _notify = value!;
                        });
                      },
                    ),
                    Text('Notificar'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: ElevatedButton(
                  onPressed: _submitMedication,
                  child: Text('Adicionar Medicamento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Medication {
  final String name;
  final String time;

  Medication({required this.name, required this.time});
}
