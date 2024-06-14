import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Fetching data for user: ${user.uid}');
      QuerySnapshot seizureSnapshot = await FirebaseFirestore.instance
          .collection('seizureEvents')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<SeizureData> data = seizureSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime date = DateFormat('yyyy-MM-dd – HH:mm').parse(data['date']);
        List<String> triggers = data['possibleTriggers'].split(', ');

        print('Event Date: $date, Triggers: $triggers');

        return SeizureData(date: date, frequency: 1, triggers: triggers);
      }).toList();

      setState(() {
        _seizureData = data;
        _calculateMonthlyAndWeeklyCounts();
        _calculateTriggerCounts();
        _isLoading = false;
      });
    }
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

    print('Monthly Counts: $_monthlyCounts');
    print('Weekly Counts: $_weeklyCounts');
  }

  void _calculateTriggerCounts() {
    _triggerCounts.clear();

    for (var data in _seizureData) {
      for (var trigger in data.triggers) {
        if (!_triggerCounts.containsKey(trigger)) {
          _triggerCounts[trigger] = 0;
        }
        _triggerCounts[trigger] = _triggerCounts[trigger]! + 1;
        print('Trigger: $trigger, Count: ${_triggerCounts[trigger]}');
      }
    }

    print('Trigger Counts: $_triggerCounts');
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
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Analytics and Insights',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildAttackCounts(),
              const SizedBox(height: 16),
              _buildTrendComparison(),
              const SizedBox(height: 16),
              _buildTriggerPieChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttackCounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attacks by Month:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ..._monthlyCounts.entries.map((entry) => Text(
          ' ${entry.value} attacks',
          style: const TextStyle(fontSize: 16),
        )),
        const SizedBox(height: 8),
        const Text(
          'Attacks by Week:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ..._weeklyCounts.entries.map((entry) => Text(
          ' ${entry.value} attacks',
          style: const TextStyle(fontSize: 16),
        )),
      ],
    );
  }

  Widget _buildTrendComparison() {
    if (_monthlyCounts.length < 2) {
      return const Text(
        'Not enough data to compare trends.',
        style: TextStyle(fontSize: 16),
      );
    }

    final sortedKeys = _monthlyCounts.keys.toList()..sort();
    final previousMonthCount = _monthlyCounts[sortedKeys[sortedKeys.length - 2]]!;
    final currentMonthCount = _monthlyCounts[sortedKeys.last]!;

    final trend = currentMonthCount > previousMonthCount
        ? 'increased'
        : currentMonthCount < previousMonthCount
        ? 'decreased'
        : 'stayed the same';

    return Text(
      'Compared to last month, your attacks have $trend.',
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildTriggerPieChart() {
    List<PieChartSectionData> sections = _triggerCounts.entries.map((entry) {
      final value = entry.value.toDouble();
      return PieChartSectionData(
        value: value,
        color: Colors.primaries[_triggerCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        radius: 50,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Most Common Triggers:',
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
                  // Handle touch events here if needed
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
      }).toList(),
    );
  }
}

class SeizureData {
  final DateTime date;
  final int frequency;
  final List<String> triggers;

  SeizureData({
    required this.date,
    required this.frequency,
    required this.triggers,
  });
}
