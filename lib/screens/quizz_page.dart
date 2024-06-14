import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/aditionalEventquestions.dart';
import '../components/models/seizure.dart';
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
  late List<String> selections;

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
        {"title": "Can’t Tell / Other", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "Jerking", "imagePath": "assets/jerking.png"},
        {"title": "Stiffness", "imagePath": "assets/Stiffness.png"},
        {"title": "Both", "imagePath": "assets/both.png"},
        {"title": "Can’t Tell / Other", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "All body Jerking", "imagePath": "assets/AllBodyJerking.png"},
        {"title": "Legs Jerking", "imagePath": "assets/cramp.png"},
        {"title": "Arm Jerking", "imagePath": "assets/ArmJerking.png"},
        {"title": "Can’t Tell / Other", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "All Body Stiffness", "imagePath": "assets/allBodyStiff.png"},
        {"title": "Legs Stiffness", "imagePath": "assets/legsStiff.png"},
        {"title": "Arm Stiffness", "imagePath": "assets/ArmStifenees.png"},
        {"title": "Can’t Tell / Other", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "Staring", "imagePath": "assets/Eyes.png"},
        {"title": "Eyes up", "imagePath": "assets/eyes up.png"},
        {"title": "Eyes down", "imagePath": "assets/eyes down.png"},
        {"title": "Eyes Rolling", "imagePath": "assets/eyes rolling.png"},
      ],
    ];

    cardTitles = [
      "Awareness",
      "Body seizure",
      "Movements",
      "Jerking Movements",
      "Stiffness",
      "Eyes"
    ];

    selections = []; // Iniciar como uma lista dinâmica
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
            SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: previous,
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: next,
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
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

  void next() async {
    if (isCardSelected) {
      if (selections.length > currentIndex) {
        selections[currentIndex] = selectedCardTitle!;
      } else {
        selections.add(selectedCardTitle!);
      }

      if (currentIndex < cardSets.length - 1) {
        setState(() {
          currentIndex++;
          isCardSelected = false;
          selectedCardTitle = null;
        });
      } else {
        final additionalQuestions = await showDialog<List<String>>(
          context: context,
          builder: (context) => AdditionalQuestionsDialog(selections: selections),
        );
        if (additionalQuestions != null) {
          selections = additionalQuestions;
          await saveSeizureEventToFirestore();
          Navigator.pop(context);
        }
      }
    }
  }

  void previous() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isCardSelected = true;
        selectedCardTitle = selections[currentIndex];
      });
    }
  }

  Future<void> saveSeizureEventToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final seizureEvent = SeizureEvent(
        userId: user.uid,
        date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        awareness: selections[0],
        bodySeizure: selections[1],
        movement: selections[2],
        jerkingMovement: selections[3],
        stiffness: selections[4],
        eyes: selections[5],
        possibleTriggers: selections.sublist(6).join(', '),
      );

      await FirebaseFirestore.instance.collection('seizureEvents').add(seizureEvent.toMap());
    }
  }
}
