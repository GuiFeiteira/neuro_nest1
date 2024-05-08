import 'package:flutter/material.dart';

class SleepOptionBar extends StatelessWidget {
  final List<String> buttonLabels = ['Melhor', 'Normal', ' Pior '];
  final List<void Function()> buttonActions = [
        () {
      print('Button 1 pressed');
    },
        () {
      print('Button 2 pressed');
    },
        () {
      print('Button 3 pressed');
    },
  ];

   SleepOptionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          for (int i = 0; i < buttonLabels.length; i++)
            ElevatedButton(
              onPressed: buttonActions[i],
              child: Text(buttonLabels[i]),
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
