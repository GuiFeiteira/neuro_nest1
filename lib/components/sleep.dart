import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SleepOptionBar extends StatefulWidget {
  const SleepOptionBar({Key? key}) : super(key: key);

  @override
  _SleepOptionBarState createState() => _SleepOptionBarState();
}

class _SleepOptionBarState extends State<SleepOptionBar> {
  String? selectedOption;
  DateTime lastSelectionDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
  }

  Future<void> _loadSelectedOption() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final sleepSelectionDoc = await FirebaseFirestore.instance
          .collection('sleepSelections')
          .doc(user.uid)
          .get();
      if (sleepSelectionDoc.exists) {
        final data = sleepSelectionDoc.data();
        if (data != null) {
          final storedOption = data['selectedOption'];
          final storedDate = (data['lastSelectionDate'] as Timestamp?)?.toDate();

          if (storedOption != null && storedDate != null) {
            if (isSameDate(storedDate, DateTime.now())) {
              setState(() {
                selectedOption = storedOption;
                lastSelectionDate = storedDate;
              });
            } else {
              await _resetSelection(user.uid);
            }
          }
        }
      }
    }
  }

  Future<void> _saveSelectedOption(String option) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final sleepSelectionDoc =
      FirebaseFirestore.instance.collection('sleepSelections').doc(user.uid);
      await sleepSelectionDoc.set({
        'selectedOption': option,
        'lastSelectionDate': DateTime.now(),
      }, SetOptions(merge: true));
      setState(() {
        selectedOption = option;
        lastSelectionDate = DateTime.now();
      });
    }
  }

  Future<void> _resetSelection(String userId) async {
    final sleepSelectionDoc =
    FirebaseFirestore.instance.collection('sleepSelections').doc(userId);
    await sleepSelectionDoc.update({
      'selectedOption': FieldValue.delete(),
      'lastSelectionDate': FieldValue.delete(),
    });
    setState(() {
      selectedOption = null;
      lastSelectionDate = DateTime.now();
    });
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedOption != null) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xF7ABACFF),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          AppLocalizations.of(context)!.thankYou,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xF7ABACFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => _saveSelectedOption('better'),
            child: Text(AppLocalizations.of(context)!.better),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(80, 30),
            ),
          ),
          ElevatedButton(
            onPressed: () => _saveSelectedOption('normal'),
            child: Text(AppLocalizations.of(context)!.normal),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(80, 30),
            ),
          ),
          ElevatedButton(
            onPressed: () => _saveSelectedOption('worst'),
            child: Text(AppLocalizations.of(context)!.worst),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(80, 30),
            ),
          ),
        ],
      ),
    );
  }
}
