import 'package:flutter/material.dart';

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

      // Close modal bottom sheet (assuming it's called from there)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nome do Medicamento'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira o nome do medicamento';
              }
              return null;
            },
          ),
          SizedBox(height: 15),
          DropdownButtonFormField<String>(
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitMedication,
            child: Text('Adicionar Medicamento'),
          ),
        ],
      ),
    );
  }
}
