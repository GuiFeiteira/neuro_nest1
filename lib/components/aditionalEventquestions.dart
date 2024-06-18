import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdditionalQuestionsDialog extends StatefulWidget {
  final List<String> selections;

  const AdditionalQuestionsDialog({Key? key, required this.selections}) : super(key: key);

  @override
  _AdditionalQuestionsDialogState createState() => _AdditionalQuestionsDialogState();
}

class _AdditionalQuestionsDialogState extends State<AdditionalQuestionsDialog> {
  final TextEditingController _additionalQuestionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();

  final List<String> selectedTriggers = [];

  final List<Map<String, String>> triggers = [
    {"emoji": "😟", "description": "Stress"},
    {"emoji": "🍷", "description": "Alcohol"},
    {"emoji": "😴", "description": "Sleep deprivation"},
    {"emoji": "💊", "description": "Missed medication"},
    {"emoji": "💡", "description": "Flashing lights or patterns"},
    {"emoji": "🤒", "description": "Infections"},
    {"emoji": "🩸", "description": "Menstruation"},
    {"emoji": "🌡️", "description": "Fever"},
    {"emoji": "🍭", "description": "Low blood sugar"},
    {"emoji": "💊", "description": "Not taking epilepsy meds"},
    {"emoji": "💧", "description": "Dehydration"},
    {"emoji": "🍽️", "description": "Skipping meals"},
    {"emoji": "☕", "description": "Caffeine"},
    {"emoji": "🦠", "description": "Disease"},
    {"emoji": "🔊", "description": "Noise"},
    {"emoji": "⏰", "description": "Time of day"},
    {"emoji": "😩", "description": "Tiredness"},
    {"emoji": "🍔", "description": "Food triggers"},

  ];

  @override
  void dispose() {
    _additionalQuestionController.dispose();
    _durationController.dispose();
    _eventTimeController.dispose();
    super.dispose();
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time != null) {
      final now = DateTime.now();
      final DateTime selectedDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      final formattedTime = DateFormat('HH:mm').format(selectedDateTime);
      setState(() {
        _eventTimeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Informações Adicionais '),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Duração do Evento (em minutos)',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _eventTimeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Hora do Evento',
              ),
              onTap: () => _showTimePicker(),
            ),
            SizedBox(height: 20),
            Text('Selecione os triggers que você acha que podem ter contribuído para o ataque:'),
            SizedBox(height: 20),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: triggers.map((trigger) {
                return FilterChip(
                  label: Text("${trigger['emoji']} ${trigger['description']}"),
                  selected: selectedTriggers.contains(trigger['description']),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTriggers.add(trigger['description']!);
                      } else {
                        selectedTriggers.remove(trigger['description']);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _additionalQuestionController,
              decoration: InputDecoration(labelText: 'Outros triggers (se houver)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.selections.add(_durationController.text);
            widget.selections.add(_eventTimeController.text);
            widget.selections.add(selectedTriggers.join(', '));


            if (_additionalQuestionController.text.isNotEmpty) {
              widget.selections.add("Outros triggers: ${_additionalQuestionController.text}");

            }
            Navigator.of(context).pop(widget.selections);
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
