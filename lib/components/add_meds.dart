import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/widgets.dart';
import '../screens/mymeds_page.dart';
import 'package:intl/intl.dart';


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
      _filteredMedications = _availableMedications;


      Navigator.pop(context);
    }
  }

  void _filterMedications(String searchTerm) {
    _filteredMedications = _availableMedications.where((medication) =>
        medication.name.toLowerCase().startsWith(searchTerm.toLowerCase())).toList();
    setState(() {});
  }

  void _showTimePicker() {
    BottomPicker.time(
      displayCloseIcon: false, // Hide close icon
      popOnClose: false,
      pickerTextStyle: TextStyle(
        fontSize: 18,

      ),
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
          _timeControllers.add(TextEditingController(text: DateFormat('HH:mm').format(time)));        });
      },
      onClose: () {},
      bottomPickerTheme: BottomPickerTheme.morningSalad,
      use24hFormat: true,
      initialTime: Time(
        minutes: 36,
        hours: 12
      ),
    ).show(context);
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

                }
                   return null;
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

          Visibility(
            visible: _selectedFrequency == 'Duas Vezes ao Dia',
            child: Column(
              children: [
                TextButton(
                  onPressed: _showTimePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time), // Clock icon
                      SizedBox(width: 10),
                      Text('Adicionar 1º horário'),
                    ],
                  ),
                ),
                if (_timeControllers.length > 0)
                  TextButton(
                    style: ButtonStyle(

                    ),
                    onPressed: _showTimePicker,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time), // Clock icon
                        SizedBox(width: 10),
                        Text('Adicionar 2º horário'),
                      ],
                    ),
                  ),
              ],
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
