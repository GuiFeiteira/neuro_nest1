import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:bottom_picker/bottom_picker.dart';
import '../components/anim_butt.dart';
import '../components/app_bar.dart';
import '../components/models/medication.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MedsPage extends StatefulWidget {
  const MedsPage({Key? key}) : super(key: key);

  @override
  State<MedsPage> createState() => _MedsPageState();
}

class _MedsPageState extends State<MedsPage> {
  List<Medication> nextMedications = [];
  List<Medication> todayMedications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('user_id', isEqualTo: user.uid)
          .get();

      List<Medication> allMedications = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> times = List<String>.from(data['times']);
        List<String> days = List<String>.from(data['days']);
        return times.map((time) => Medication(
          name: data['name'],
          time: time,
          days: days,
          isTaken: data['taken_dates']?.contains(_getCurrentDateKey(time)) ?? false,
          id: doc.id,
        )).toList();
      }).expand((element) => element).toList();


      _filterAndSortMedications(allMedications);
    }

    setState(() {
      isLoading = false;
    });
  }

  void _filterAndSortMedications(List<Medication> medications) {
    DateTime now = DateTime.now();
    String currentDay = _normalizeDay(DateFormat('EEEE').format(now));
    DateFormat timeFormat = DateFormat('HH:mm');


    List<Medication> todayMeds = medications.where((med) {

      return med.days.map(_normalizeDay).contains(currentDay);
    }).toList();


    todayMeds.sort((a, b) => timeFormat.parse(a.time).compareTo(timeFormat.parse(b.time)));

    nextMedications = todayMeds.where((med) {
      DateTime medTime = timeFormat.parse(med.time);
      bool isNext = !med.isTaken && (medTime.hour > now.hour || (medTime.hour == now.hour && medTime.minute > now.minute));

      return isNext;
    }).take(3).toList();


    todayMedications = todayMeds;

    setState(() {});
  }

  String _normalizeDay(String day) {
    return day.trim().toLowerCase();
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  String _getCurrentDateKey(String time) {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $time";
  }

  Future<void> _toggleMedicationTaken(Medication medication) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('medications').doc(medication.id);

      setState(() {
        medication.isTaken = !medication.isTaken;
      });

      if (medication.isTaken) {
        await docRef.update({
          'taken_dates': FieldValue.arrayUnion([_getCurrentDateKey(medication.time)]),
        });
      } else {
        await docRef.update({
          'taken_dates': FieldValue.arrayRemove([_getCurrentDateKey(medication.time)]),
        });
      }
    }
  }

  Future<void> _showDifferentTimingDialog(Medication medication) async {
    BottomPicker.time(
      displayCloseIcon: false,
      pickerTextStyle: TextStyle(fontSize: 18),
      pickerTitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppLocalizations.of(context)!.meddstime,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: CupertinoColors.systemTeal,
          ),
        ),
      ),
      use24hFormat: true,
      onSubmit: (selectedDateTime) async {
        final String newTime = DateFormat('HH:mm').format(selectedDateTime);

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final docRef = FirebaseFirestore.instance.collection('medications').doc(medication.id);
          await docRef.update({
            'taken_dates': FieldValue.arrayUnion([_getCurrentDateKey('Diferent Timing - $newTime')]),
          });
          setState(() {
            medication.isTaken = true;
          });
        }
      }, initialTime: null,
    ).show(context);
  }

  Future<void> _showSkippedDialog(Medication medication) async {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Skipped ${medication.name}'),
          content: TextField(
            controller: reasonController,
            decoration: InputDecoration(
              labelText: 'Enter reason for skipping',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final docRef = FirebaseFirestore.instance.collection('medications').doc(medication.id);
                  String reason = reasonController.text.trim();
                  await docRef.update({
                    'taken_dates': FieldValue.arrayUnion([_getCurrentDateKey("skipped - $reason")]),
                  });
                  setState(() {
                    medication.isTaken = true;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8ECFF),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: nextMedications.isEmpty ? 0 : (nextMedications.length +1) * 60.0,
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0x63DAAAFF)),
            child: nextMedications.isEmpty
                ? Container()
                : Padding(
              padding: const EdgeInsets.only(top: 15, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: Text(
                      AppLocalizations.of(context)!.proximos,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: nextMedications.length,
                      itemBuilder: (context, index) {
                        final medication = nextMedications[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              Line8(), // Separator line
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  medication.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Text(
                                  medication.time,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFFF8ECFF)),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: Text(
                       AppLocalizations.of(context)!.medstoday,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: todayMedications.length,
                        itemBuilder: (context, index) {
                          final medication = todayMedications[index];
                          return GestureDetector(
                            onTap: () {
                              _toggleMedicationTaken(medication);
                            },
                            child: Row(
                              children: [
                                if (medication.isTaken)
                                  const Icon(Icons.check_outlined, color: Color(0xFF9D4EDD), size: 29),
                                if (!medication.isTaken)
                                  Line8(),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    medication.name,
                                    style: TextStyle(
                                      color: medication.isTaken ? Colors.grey : Colors.black,
                                      fontSize: 16,
                                      decoration: medication.isTaken ? TextDecoration.lineThrough : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                                  onSelected: (String value) {
                                    if (value == 'Different Timing') {
                                      _showDifferentTimingDialog(medication);
                                    } else if (value == 'Skipped') {
                                      _showSkippedDialog(medication);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'Different Timing',
                                        child: Text(AppLocalizations.of(context)!.diferentiming),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Skipped',
                                        child: Text(AppLocalizations.of(context)!.skipped),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBarCustom(selectedIndex: 1),
    );
  }
}
