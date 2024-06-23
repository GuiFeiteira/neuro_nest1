import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' as DateRangePicker;
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import '../components/app_bar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, List<Map<String, String>>> _events = {};
  Map<String, List<String>> _medicationsTaken = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _generatePdfReport(DateTime startDate, DateTime endDate) async {
    // 1. Filter Data:
    final filteredEvents = _events.entries.where((entry) {
      final date = DateFormat('yyyy-MM-dd').parse(entry.key);
      return date.isAfter(startDate) && date.isBefore(endDate);
    }).toList();

    final filteredMedications = _medicationsTaken.entries.where((entry) {
      final date = DateFormat('yyyy-MM-dd').parse(entry.key);
      return date.isAfter(startDate) && date.isBefore(endDate);
    }).toList();

    // 2. Create PDF Document:
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Relatório de Eventos e Medicações'),
            pw.Text('Período: ${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}'),
            pw.SizedBox(height: 20),
            for (var entry in filteredEvents)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(entry.key, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), // Date header
                  for (var event in entry.value)
                    pw.Text('- ${event['Event']}'),
                ],
              ),
            pw.SizedBox(height: 20),
            for (var entry in filteredMedications)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(entry.key, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), // Date header
                  for (var medication in entry.value)
                    pw.Text('- $medication'),
                ],
              ),
          ],
        );
      },
    ));

    // 3. Save PDF to local storage:
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/report.pdf');
    await file.writeAsBytes(await pdf.save());

    // 4. Show confirmation to the user:
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Relatório Gerado'),
        content: Text('O relatório foi salvo em ${file.path}'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {

      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('user_id', isEqualTo: user.uid)
          .get();

      Map<String, List<Map<String, String>>> events = {};
      for (var doc in eventSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String date = data['date'];
        String event = data['event'];
        if (!events.containsKey(date)) {
          events[date] = [];
        }
        events[date]!.add({'Event': event});
      }

      QuerySnapshot medicationSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('user_id', isEqualTo: user.uid)
          .get();

      Map<String, List<String>> medicationsTaken = {};
      for (var doc in medicationSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> takenDates = List<String>.from(data['taken_dates'] ?? []);
        String medicationName = data['name'];
        for (String takenDate in takenDates) {
          List<String> dateAndTime = takenDate.split(' ');
          String dateKey = dateAndTime.first;
          String timeAndStatus = dateAndTime.skip(1).join(' ');
          String medicationInfo = '$medicationName - $timeAndStatus';

          if (!medicationsTaken.containsKey(dateKey)) {
            medicationsTaken[dateKey] = [];
          }
          medicationsTaken[dateKey]!.add(medicationInfo);
        }
      }

      // Carregar eventos de ataque do Firestore
      QuerySnapshot seizureSnapshot = await FirebaseFirestore.instance
          .collection('seizureEvents')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in seizureSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String date = data['date'];
        String awareness = data['awareness'];
        String bodySeizure = data['bodySeizure'];
        String movement = data['movement'];
        String jerkingMovement = data['jerkingMovement'];
        String stiffness = data['stiffness'];
        String eyes = data['eyes'];
        String possibleTriggers = data['possibleTriggers'];

        String formattedDate = date.split(' ').first;

        Map<String, String> event = {
          'Awareness': awareness,
          'Body Seizure': bodySeizure,
          'Movement': movement,
          'Jerking Movement': jerkingMovement,
          'Stiffness': stiffness,
          'Eyes': eyes,
          'Triggers': possibleTriggers
        };

        if (!events.containsKey(formattedDate)) {
          events[formattedDate] = [];
        }
        events[formattedDate]!.add(event);
      }

      setState(() {
        _events = events;
        _medicationsTaken = medicationsTaken;
        print(_events);
      });
    }
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    String key = DateFormat('yyyy-MM-dd').format(day);
    return _events[key] ?? [];
  }

  List<String> _getMedicationsForDay(DateTime day) {
    String key = DateFormat('yyyy-MM-dd').format(day);
    return _medicationsTaken[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8ECFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(10),
                ),
                color: const Color(0x63DAAAFF).withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TableCalendar(
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                    weekendTextStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getEventsForDay,
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            if (_selectedDay != null) ...[
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(0x63DAAAFF),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)?.eventosdia ?? 'Eventos do dia:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Column(
                children: _getEventsForDay(_selectedDay!).map((event) {
                  return Column(
                    children: [
                      DataTable(
                        columns:  [
                          DataColumn(label: Text(AppLocalizations.of(context)!.tipo)),
                          DataColumn(label: Text(AppLocalizations.of(context)!.detalhes)),
                        ],
                        rows: event.entries.map((entry) {
                          return DataRow(
                            cells: [
                              DataCell(Text(entry.key)),
                              DataCell(Text(entry.value)),
                            ],
                          );
                        }).toList(),
                      ),
                      Divider(
                        color: Colors.deepPurple,
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(0x63DAAAFF),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.medicamentosdia,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataTable(
                columns: [
                  DataColumn(label: Text(AppLocalizations.of(context)!.medicamento)),
                ],
                rows: _getMedicationsForDay(_selectedDay!).map((medication) {
                  return DataRow(
                    cells: [
                      DataCell(Text(medication)),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    initialDateRange: DateTimeRange(start: _selectedDay!, end: _selectedDay!),
                  );

                  if (picked != null) {
                    DateTime startDate = picked.start;
                    DateTime endDate = picked.end;
                    await _generatePdfReport(startDate, endDate);
                  }
                },
                child: Text('Gerar Relatório PDF'),
              ),
              SizedBox(height: 20),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBarCustom(selectedIndex: 3),
    );
  }
}
