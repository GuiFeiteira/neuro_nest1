import 'package:flutter/material.dart';

class MoodOptionBar extends StatelessWidget {
  final List<String> emojiLabels = ['😀', '🙂', '😐', '😞', '😡', '😭'];
  final List<String> moodDescriptions = ['Feliz', 'Bom', 'Normal', 'Triste', 'Zangado', 'Muito Triste'];
  final List<void Function()> emojiActions = [
        () {
      print('O utilizador está Feliz');
    },
        () {
      print('O utilizador está Bom');
    },
        () {
      print('O utilizador está Normal');
    },
        () {
      print('O utilizador está Triste');
    },
        () {
      print('O utilizador está Zangado');
    },
        () {
      print('O utilizador está Muito Triste');
    },
  ];

  MoodOptionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xF7ABACFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < emojiLabels.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: emojiActions[i],
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20, // Adjust radius as needed
                        child: Text(
                          emojiLabels[i],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(40, 40),
                        shape: CircleBorder(),
                        elevation: 0, // Remove elevation to match CircleAvatar
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}