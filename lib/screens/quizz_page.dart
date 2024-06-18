import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/aditionalEventquestions.dart';
import '../components/models/seizure.dart';
import '../components/quizz_card.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


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
        {"title": "fullyAware", "imagePath": "assets/fully aware.png"},
        {"title": "confused", "imagePath": "assets/confused.png"},
        {"title": "respondsToVoice", "imagePath": "assets/Responds_voice.png"},
        {"title": "notResponsive", "imagePath": "assets/not responsive.png"},
      ],
      [
        {"title": "fullBody", "imagePath": "assets/full body.png"},
        {"title": "justRightSide", "imagePath": "assets/right.png"},
        {"title": "justLeftSide", "imagePath": "assets/left.png"},
        {"title": "cantTellOther", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "jerking", "imagePath": "assets/jerking.png"},
        {"title": "stiffness", "imagePath": "assets/Stiffness.png"},
        {"title": "both", "imagePath": "assets/both.png"},
        {"title": "cantTellOther", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "allBodyJerking", "imagePath": "assets/AllBodyJerking.png"},
        {"title": "legsJerking", "imagePath": "assets/cramp.png"},
        {"title": "armJerking", "imagePath": "assets/ArmJerking.png"},
        {"title": "cantTellOther", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "allBodyStiffness", "imagePath": "assets/allBodyStiff.png"},
        {"title": "legsStiffness", "imagePath": "assets/legsStiff.png"},
        {"title": "armStiffness", "imagePath": "assets/ArmStifenees.png"},
        {"title": "cantTellOther", "imagePath": "assets/question.png"},
      ],
      [
        {"title": "staring", "imagePath": "assets/Eyes.png"},
        {"title": "eyesUp", "imagePath": "assets/eyes up.png"},
        {"title": "eyesDown", "imagePath": "assets/eyes down.png"},
        {"title": "Yeys ROlling", "imagePath": "assets/eyes rolling.png"},
      ],
    ];

    cardTitles = [
      "awareness",
      "bodySeizure",
      "movements",
      "jerkingMovements",
      "stiffness",
      "eyes"
    ];

    selections = [];
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
                      AppLocalizations.of(context)!.back,
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
                      AppLocalizations.of(context)!.next,
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
          print(selections);

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
        possibleTriggers: selections.sublist(8).join(', '),
        duration: selections[6],
        eventTime: selections[7],
      );

      await FirebaseFirestore.instance.collection('seizureEvents').add(seizureEvent.toMap());
    }
  }
}
