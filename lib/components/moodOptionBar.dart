import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MoodOptionBar extends StatefulWidget {
  @override
  _MoodOptionBarState createState() => _MoodOptionBarState();
}

class _MoodOptionBarState extends State<MoodOptionBar> {
  final List<String> imagePaths = [
    'assets/realhappy.png',
    'assets/happy.png',
    'assets/normal.png',
    'assets/stress.png',
    'assets/litlesad.png',
    'assets/angry.png',
    'assets/sad.png',
  ];

  String? _selectedMood;
  String? _selectedDescription;
  String? _selectedImagePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedMood == null) {
      _selectedMood = AppLocalizations.of(context)!.happy;
      _selectedDescription = AppLocalizations.of(context)!.happy;
      _selectedImagePath = imagePaths[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> moodDescriptions = [
      AppLocalizations.of(context)!.happy,
      AppLocalizations.of(context)!.good,
      AppLocalizations.of(context)!.normal,
      AppLocalizations.of(context)!.stressed,
      AppLocalizations.of(context)!.littleSad,
      AppLocalizations.of(context)!.angry,
      AppLocalizations.of(context)!.verySad,
    ];

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
          Container(
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),

            ),
            child: DropdownButton<String>(
              hint: _selectedMood != null
                  ? Row(
                children: [
                  SizedBox(width: 10),
                  Image.asset(
                    _selectedImagePath!,
                    width: 27,
                    height: 27,
                  ),
                  SizedBox(width: 18),
                  Text(_selectedMood!),
                  SizedBox(width: 18,)
                ],
              )
                  : null,
              items: List.generate(imagePaths.length, (index) {
                return DropdownMenuItem<String>(
                  value: moodDescriptions[index],
                  child: Row(
                    children: [
                      SizedBox(width: 10),
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
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _saveMood,
              child: Text(AppLocalizations.of(context)!.save),
            ),
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
    }
  }
}
