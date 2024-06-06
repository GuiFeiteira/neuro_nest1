import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipo_treino/screens/home_page.dart';
import 'package:tipo_treino/screens/mymeds_page.dart';
import '../screens/quizz_page.dart';
import 'add_meds.dart';

class BottomAppBarCustom extends StatefulWidget {
  final int selectedIndex;

  const BottomAppBarCustom({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _BottomAppBarCustomState createState() => _BottomAppBarCustomState();
}

class _BottomAppBarCustomState extends State<BottomAppBarCustom> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index != 2) return;

    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MedsPage()),
        );
        break;
      case 2:
        showModalBottomSheet<void>(
          isDismissible: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  width: 200.0,
                  height: 50.0,
                  child: FloatingActionButton.extended(
                    label: const Text('Add Event'),
                    icon: const Icon(Icons.sensor_occupied_sharp),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizPage()),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  width: 200.0,
                  height: 50.0,
                  child: FloatingActionButton.extended(
                    label: const Text('Add Medication'),
                    icon: const Icon(Icons.medication_outlined),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (BuildContext context) {
                          return AddMedicationForm(
                            onSuccess: (medicationName, dosageFrequency) {
                              print('Medication added $medicationName, ');
                            },
                          );
                        },
                      );
                    },
                    backgroundColor: Colors.white,
                  ),
                ),

                SizedBox(height: 15),
                Container(
                  width: 200.0,
                  height: 50.0,
                  child: FloatingActionButton.extended(
                    label: const Text('Add Habit'),
                    icon: const Icon(Icons.sports_handball_sharp),
                    onPressed: () {
                      AwesomeNotifications().createNotification(
                          content: NotificationContent(
                              id: 1,
                              channelKey: 'not_channel',
                              title: 'Helloooooo',
                              body: 'MAluco sao horas cde tomares as tuas drogas'
                          ),

                      );
                    },
                    backgroundColor: Colors.white,
                  ),
                ),

                SizedBox(height: 130),
              ],
            );
          },
        );
        break;
      case 3:
      // Navegação para a página de calendário
        break;
      case 4:
      // Navegação para a página de SOS
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
        color: Color(0xFFC77DFF),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => _onItemTapped(0),
            icon: Icon(
              _selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => _onItemTapped(1),
            icon: _selectedIndex == 1
                ? Image.asset(
              'assets/pills.png',
              width: 35,
              height: 35,
              color: Colors.white,
            )
                : Image.asset(
              'assets/pills_outlined.png',
              width: 35,
              height: 35,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => _onItemTapped(2),
            icon: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xFF9D4EDD),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Icon(
                CupertinoIcons.plus,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _onItemTapped(3),
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.calendar_today
                  : Icons.calendar_today_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => _onItemTapped(4),
            icon: Icon(
              _selectedIndex == 4 ? Icons.sos : Icons.sos_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
