import 'package:flutter/material.dart';
import '../components/quizz_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  late List<List<Map<String, String>>> cardSets;
  late List<String> cardTitles;

  String? selectedCardTitle;
  bool isCardSelected = false;

  @override
  void initState() {
    super.initState();

    cardSets = [
      [
        {"title": "Fully Aware", "imagePath": "assets/fully aware.png"},
        {"title": "Confused", "imagePath": "assets/confused.png"},
        {"title": "Responds to Voice", "imagePath": "assets/Responds_voice.png"},
        {"title": "Not Responsive", "imagePath": "assets/not responsive.png"},
      ],
      [
        {"title": "Full Body", "imagePath": "assets/full body.png"},
        {"title": "Just Right Side", "imagePath": "assets/right.png"},
        {"title": "Just Left Side", "imagePath": "assets/left.png"},
        {"title": "Can’t Tell / Other", "imagePath":""},
      ],
      [
        {"title": "Jerking", "imagePath": "assets/jerking.png"},
        {"title": "Stiffness", "imagePath": "assets/Stiffness.png"},
        {"title": "Both", "imagePath": "assets/both.png"},
        {"title": "Can’t Tell / Other", "imagePath":""},
      ],
    ];

    cardTitles = [
      "Awareness",
      "Body seizure",
      "Movements",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8ECFF),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                cardTitles[currentIndex],
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < 2; i++)
                  QuizzCard(
                    title: cardSets[currentIndex][i]["title"]!,
                    imagePath: cardSets[currentIndex][i]["imagePath"]!,
                    onSelected: (title) => handleCardSelection(title),
                    opacity: isCardSelected && selectedCardTitle != null && selectedCardTitle != cardSets[currentIndex][i]["title"]! ? 0.5 : 1.0,
                  ),
              ],
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 2; i < 4; i++)
                  QuizzCard(
                    title: cardSets[currentIndex][i]["title"]!,
                    imagePath: cardSets[currentIndex][i]["imagePath"]!,
                    onSelected: (title) => handleCardSelection(title),
                    opacity: isCardSelected && selectedCardTitle != null && selectedCardTitle != cardSets[currentIndex][i]["title"]! ? 0.5 : 1.0,
                  ),
              ],
            ),
            SizedBox(height: 40.0),
            Row(
              children: [
                TextButton(
                  onPressed: currentIndex > 0 ? () => handleBack() : null,
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 8),
                      Text("Back"),
                    ],
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: currentIndex < cardSets.length - 1 ? () => handleNext() : null,
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Row(
                    children: [
                      Text("Next"),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleCardSelection(String title) {
    setState(() {
      selectedCardTitle = title;
      isCardSelected = true;
    });
  }

  void handleNext() {
    setState(() {
      if (currentIndex < cardSets.length - 1) {
        currentIndex++;
        selectedCardTitle = null;
        isCardSelected = false;
      }
    });
  }

  void handleBack() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        selectedCardTitle = null;
        isCardSelected = false;
      }
    });
  }
}
