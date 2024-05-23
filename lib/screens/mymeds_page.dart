import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../components/anim_butt.dart';
import '../components/app_bar.dart';

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
        return times.map((time) => Medication(name: data['name'], time: time)).toList();
      }).expand((element) => element).toList();
      print('Medicamentos recuperados:');
      allMedications.forEach((med) {
        print('${med.name} - ${med.time}');
      });

      _filterAndSortMedications(allMedications);
    }


    setState(() {
      isLoading = false;
    });
  }

  void _filterAndSortMedications(List<Medication> medications) {
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat('HH:mm');



    nextMedications = medications.where((med) {
      DateTime medTime = timeFormat.parse(med.time);
      return medTime.hour >= now.hour && medTime.minute >= now.minute;
    }).take(3).toList();

    todayMedications = medications.where((med) {
      DateTime medTime = timeFormat.parse(med.time);

      return medTime.hour >= now.hour && medTime.minute >= now.minute;
    }).toList();


    print('Próximos medicamentos:');
    nextMedications.forEach((med) {
      print('${med.name} - ${med.time}');
    });

    print('Medicamentos de hoje:');
    todayMedications.forEach((med) {
      print('${med.name} - ${med.time}');
    });

    // Atualiza a lista de medicamentos na interface do usuário
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8ECFF),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0x63DAAAFF)),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        "Next On:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 23),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: nextMedications.length,
                      itemBuilder: (context, index) {
                        final medication = nextMedications[index];
                        return Row(
                          children: [
                            Line8(), // Separator line
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                medication.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Text(
                                medication.time,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xFFF8ECFF)),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        "Today's Medications:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 23),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: todayMedications.length,
                      itemBuilder: (context, index) {
                        final medication = todayMedications[index];
                        return Row(
                          children: [
                            Line8(), // Separator line
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                medication.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.grey, size: 24),
                                onSelected: (value) {
                                  if (value == 'Different Timing') {
                                    // Handle edit action
                                  } else if (value == 'Skipped') {
                                    // Handle delete action
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'Different Timing',
                                      child: Text('Different Timing'),
                                    ),
                                    PopupMenuItem(
                                      value: 'Skipped',
                                      child: Text('Skipped'),
                                    ),
                                  ];
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottonAppBar(),
    );
  }
}

class Medication {
  final String name;
  final String time;

  Medication({required this.name, required this.time});
}
