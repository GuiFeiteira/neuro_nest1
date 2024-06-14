import 'package:flutter/material.dart';

class AdditionalQuestionsDialog extends StatefulWidget {
  final List<String> selections;

  const AdditionalQuestionsDialog({Key? key, required this.selections}) : super(key: key);

  @override
  _AdditionalQuestionsDialogState createState() => _AdditionalQuestionsDialogState();
}

class _AdditionalQuestionsDialogState extends State<AdditionalQuestionsDialog> {
  final TextEditingController _additionalQuestionController = TextEditingController();
  final List<String> selectedTriggers = [];

  final List<Map<String, String>> triggers = [
    {"emoji": "😟", "description": "Stress"},
    {"emoji": "🍷", "description": "Alcohol"},
    {"emoji": "😴", "description": "Sleep deprivation"},
    {"emoji": "💊", "description": "Missed medication"},
    {"emoji": "♀️", "description": "Hormones"},
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
    {"emoji": "🛌", "description": "Sleep"},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Quais foram os triggers do ataque?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            // Salvar os triggers selecionados na lista `selections`
            widget.selections.add("${selectedTriggers.join(', ')}");
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
