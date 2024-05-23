import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipo_treino/screens/home_page.dart';
import 'package:tipo_treino/screens/mymeds_page.dart';
import '../screens/quizz_page.dart';
import 'add_meds.dart';

class BottonAppBar extends StatefulWidget {
  const BottonAppBar({Key? key}) : super(key: key);

  @override
  _BottonAppBarState createState() => _BottonAppBarState();
}

class _BottonAppBarState extends State<BottonAppBar> {
  int _selectedIndex = 0;

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
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()
                  ));

            },
            icon: Icon(
              _selectedIndex == 0
                  ? Icons.home_rounded
                  : Icons.home_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {

              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => MedsPage()

                  ));
              setState(() {
                _selectedIndex = 1;
              });
            },
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
            onPressed: () {
              showModalBottomSheet<void>(
                isDismissible: true,
                backgroundColor: Colors.transparent,
                context: context,
                  builder: (BuildContext context){
                    return SizedBox(
                    height: 300,
                        child: Center(
                        child: Column(
                        children: <Widget>[

                          ElevatedButton(

                          child: const Text('Add Event'),
                          onPressed: () =>                                               Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPage())),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),

                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            child: const Text('Add Medication'),
                            onPressed: (){
                              showModalBottomSheet<void>(
                                isScrollControlled: true,
                                useSafeArea: true,
                                  constraints: BoxConstraints(maxHeight: 600),
                                  context: context,
                                  builder: (BuildContext context){
                                    return AddMedicationForm(
                                        onSuccess: (medicationName, dosageFrequency){
                                          print('Medication added $medicationName, ');
                                        }
                                        );
                                  },

                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),

                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            child: const Text('Add Habit '),
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(

                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),

                            ),
                          ),
                        ]
                    )
                        )
                    );
                  }
              );

              setState(() {
                _selectedIndex = 2;
              });

            },
            icon: Container(height: 50, width: 50,
              decoration: BoxDecoration(
                color: Color(0xFF9D4EDD),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Icon(
                _selectedIndex == 2
                    ? CupertinoIcons.plus
                    : CupertinoIcons.plus,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {

              setState(() {
                _selectedIndex = 3;
              });
            },
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.calendar_today
                  : Icons.calendar_today_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 4;
              });
            },
            icon: Icon(
              _selectedIndex == 4
                  ? Icons.sos
                  : Icons.sos_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}