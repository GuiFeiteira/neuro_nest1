import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class SleepOptionBar extends StatelessWidget {
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
          ElevatedButton(
            onPressed: buttonActions[0],
            child: Text(AppLocalizations.of(context)!.better),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(80, 30),
            ),
          ),
          ElevatedButton(
            onPressed: buttonActions[1],
            child: Text(AppLocalizations.of(context)!.normal),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(80, 30),
            ),
          ),
          ElevatedButton(
            onPressed: buttonActions[2],
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
