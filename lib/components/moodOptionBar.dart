import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MoodOptionBar extends StatefulWidget {
  @override
  _MoodOptionBarState createState() => _MoodOptionBarState();
}

class _MoodOptionBarState extends State<MoodOptionBar> {
  final List<String> imagePaths = [
    'assets/happy.png',
    'assets/happy.png',
    'assets/normal.png',
    'assets/stress.png',
    'assets/litlesad.png',
    'assets/angry.png',
    'assets/sad.png',
  ];
  final List<String> moodDescriptions = [
    'Feliz', 'Bom', 'Normal','Stressado', 'Triste', 'Zangado', 'Muito Triste'
  ];
  String? _selectedMood;
  String? _selectedDescription;
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xF7ABACFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: _selectedMood,
            items: List.generate(imagePaths.length, (index) {
              return DropdownMenuItem<String>(
                value: moodDescriptions[index],
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Image.asset(
                      imagePaths[index],
                      width: 27,
                      height: 27,
                    ),
                    SizedBox(width: 18),
                    Text(moodDescriptions[index]),
                  ],
                ),
              );
            }),
            onChanged: (value) {
              setState(() {
                _selectedMood = value;
                int selectedIndex = moodDescriptions.indexOf(value!);
                _selectedDescription = moodDescriptions[selectedIndex];
                _selectedImagePath = imagePaths[selectedIndex];
              });
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),

            ) ,
            onPressed: _selectedMood == null ? null : _saveMood,
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMood() async {
    if (_selectedMood == null || _selectedDescription == null || _selectedImagePath == null) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime now = DateTime.now();
      String date = DateFormat('yyyy-MM-dd').format(now);
      String time = DateFormat('HH:mm').format(now);

      await FirebaseFirestore.instance.collection('moodEntries').add({
        'userId': user.uid,
        'mood': _selectedDescription,
        'date': date,
        'time': time,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Humor salvo com sucesso!')));
    }
  }
}
