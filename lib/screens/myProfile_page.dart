import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List<SeizureData> _seizureData = [];
  Map<String, int> _monthlyCounts = {};
  Map<String, int> _weeklyCounts = {};
  Map<String, int> _triggerCounts = {};
  Map<String, int> _hourlyCounts = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot seizureSnapshot = await FirebaseFirestore.instance
          .collection('seizureEvents')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<SeizureData> data = seizureSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime date = DateFormat('yyyy-MM-dd – HH:mm').parse(data['date']);
        List<String> triggers = data['possibleTriggers'].split(', ');
        String eventTime = data['eventTime'];


        return SeizureData(date: date, frequency: 1, triggers: triggers, eventTime: eventTime,);
      }).toList();

      setState(() {
        _seizureData = data;
        _calculateMonthlyAndWeeklyCounts();
        _calculateTriggerCounts();
        _calculateHourlyCounts();
        _isLoading = false;
      });
    }
  }
  void _calculateHourlyCounts() {
    Map<String, int> hourlyCounts = {};

    for (var data in _seizureData) {
      String hourKey = data.eventTime.split(':')[0]; // Extract hour from eventTime

      hourlyCounts[hourKey] = (hourlyCounts[hourKey] ?? 0) + 1;
    }

    // Sort by hour (optional)
    final sortedEntries = hourlyCounts.entries.toList()
      ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));
    _hourlyCounts = Map.fromEntries(sortedEntries);

  }
  void _calculateMonthlyAndWeeklyCounts() {
    _monthlyCounts.clear();
    _weeklyCounts.clear();

    for (var data in _seizureData) {
      String monthKey = DateFormat('yyyy-MM').format(data.date);
      String weekKey = DateFormat('yyyy-ww').format(data.date);

      if (!_monthlyCounts.containsKey(monthKey)) {
        _monthlyCounts[monthKey] = 0;
      }
      _monthlyCounts[monthKey] = _monthlyCounts[monthKey]! + data.frequency;

      if (!_weeklyCounts.containsKey(weekKey)) {
        _weeklyCounts[weekKey] = 0;
      }
      _weeklyCounts[weekKey] = _weeklyCounts[weekKey]! + data.frequency;
    }
  }

  void _calculateTriggerCounts() {
    _triggerCounts.clear();
    for (var data in _seizureData) {
      for (var trigger in data.triggers) {
        if(trigger.isNotEmpty){
          if (!_triggerCounts.containsKey(trigger)) {
            _triggerCounts[trigger] = 0;
          }
          _triggerCounts[trigger] = _triggerCounts[trigger]! + 1;
        }
      }
    }
  }

  Widget _buildHourlyBarChart() {

    final List<BarChartGroupData> barGroups = _hourlyCounts.entries.map((entry) {
      return BarChartGroupData(
        x: int.parse(entry.key),
        barsSpace: 0.1,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 18,
          ),
        ],
      );
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.seizureByHour,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text('${value.toInt()}h',
                      style: TextStyle(
                        fontSize: 12,

                      ),
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 1,

                      getTitlesWidget: (value, meta){
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15
                          ),
                        );

                      }
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

              ),
            ),
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8ECFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8ECFF),
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                AppLocalizations.of(context)!.analises,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildAttackCounts(),
              const SizedBox(height: 16),
              _buildTrendComparison(),
              const SizedBox(height: 10),
              Divider(
                thickness: 4,
              ),
              const SizedBox(height: 10),
              _buildHourlyBarChart(),
              const SizedBox(height: 10),
              Divider(
                thickness: 4,
              ),
              const SizedBox(height: 10),
              _buildTriggerPieChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttackCounts() {
    final now = DateTime.now();
    final currentMonth = DateFormat('yyyy-MM').format(now);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.ataquesmes,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (_monthlyCounts.containsKey(currentMonth))
          Text(
            '${_monthlyCounts[currentMonth]} attacks',
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }


  Widget _buildTrendComparison() {
    if (_monthlyCounts.length < 2) {
      return Text(
        AppLocalizations.of(context)!.trends,
        style: TextStyle(fontSize: 16),
      );
    }

    final sortedKeys = _monthlyCounts.keys.toList()..sort();
    final previousMonthCount = _monthlyCounts[sortedKeys[sortedKeys.length - 2]]!;
    final currentMonthCount = _monthlyCounts[sortedKeys.last]!;

    final trend = currentMonthCount > previousMonthCount
        ? AppLocalizations.of(context)!.increased
        : currentMonthCount < previousMonthCount
        ? AppLocalizations.of(context)!.decreased
        : AppLocalizations.of(context)!.stayedTheSame;

    return Text(
      '${AppLocalizations.of(context)!.comparedToLastMonth} $trend.',
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildTriggerPieChart() {
    List<PieChartSectionData> sections = _triggerCounts.entries.map((entry) {
      final value = entry.value.toDouble();
      return PieChartSectionData(
        value: value,
        title: '',
        color: Colors.primaries[_triggerCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        radius: 50,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.mostcomun,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (touchEvent, pieTouchResponse) {
                  if (pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                    final touchedSection = pieTouchResponse.touchedSection!;
                    final sectionIndex = touchedSection.touchedSectionIndex;
                    final section = sections[sectionIndex];
                    final trigger = _triggerCounts.entries.elementAt(sectionIndex);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Trigger Information'),
                          content: Text('Trigger: ${trigger.key}\nOccurrences: ${trigger.value}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }


  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _triggerCounts.entries.map((entry) {
        final color = Colors.primaries[_triggerCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length];
        return Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(entry.key, style: const TextStyle(fontSize: 16)),
          ],
        );
      }).take(8).toList(),
    );
  }
}

class SeizureData {
  final DateTime date;
  final int frequency;
  final List<String> triggers;
  String eventTime;


  SeizureData({
    required this.date,
    required this.frequency,
    required this.triggers,
    required this.eventTime,
  });
}