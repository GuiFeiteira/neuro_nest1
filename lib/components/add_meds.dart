import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import '../screens/mymeds_page.dart';

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
    super.dispose();
  }

  void _submitMedication() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final frequency = _selectedFrequency!;

      // Handle successful medication addition (replace with your logic)
      // You can show a success message, store data locally, etc.
      widget.onSuccess(name, frequency);

      // Clear form fields
      _nameController.clear();
      _selectedFrequency = null;
      _filteredMedications = _availableMedications; // Reset filtered list

      // Close modal bottom sheet (assuming it's called from there)
      Navigator.pop(context);
    }
  }

  void _filterMedications(String searchTerm) {
    _filteredMedications = _availableMedications.where((medication) =>
        medication.name.toLowerCase().startsWith(searchTerm.toLowerCase())).toList();
    setState(() {});
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
              decoration: InputDecoration(

                  labelText: 'Nome do Medicamento',

              ),

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
                   if (index < 4) {

                  final medication = _filteredMedications[index];
                  return ListTile(

                    tileColor: Colors.white,
                    title: Text(medication.name),
                    onTap: () {
                      _nameController.text = medication.name;
                      _selectedFrequency = null; // Redefine a seleção de frequência
                      setState(() {
                        _filteredMedications.clear(); // Limpa a lista de medicamentos para fechá-la
                      });
                    },
                  );
                } else {

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
          BottomPicker.time(
            pickerTitle: Text(
              'Qual o horario de toma?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: CupertinoColors.systemTeal,
              ),
            ),
            onSubmit: (index){
              print(index);
            },
            onClose: (){
              print('object');
            },
            bottomPickerTheme: BottomPickerTheme.morningSalad,
            use24hFormat: true,
            initialTime: Time(
              minutes: 16,
            ),

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
