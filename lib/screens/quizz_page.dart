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
  void didChangeDependencies() {
    super.didChangeDependencies();

    cardSets = [
      [
        {"title": AppLocalizations.of(context)!.fullyAware, "imagePath": "assets/fully aware.png"},
        {"title": AppLocalizations.of(context)!.confused, "imagePath": "assets/confused.png"},
        {"title": AppLocalizations.of(context)!.respondsToVoice, "imagePath": "assets/Responds_voice.png"},
        {"title": AppLocalizations.of(context)!.notResponsive, "imagePath": "assets/not responsive.png"},
        {"title": AppLocalizations.of(context)!.cantTellOther, "imagePath": "assets/question.png"},
        {"title": AppLocalizations.of(context)!.none, "imagePath": "assets/close.png"},
      ],
      [
        {"title": AppLocalizations.of(context)!.fullBody, "imagePath": "assets/full body.png"},
        {"title": AppLocalizations.of(context)!.justRightSide, "imagePath": "assets/right.png"},
        {"title": AppLocalizations.of(context)!.justLeftSide, "imagePath": "assets/left.png"},
        {"title": AppLocalizations.of(context)!.cantTellOther, "imagePath": "assets/question.png"},
        {"title": AppLocalizations.of(context)!.none, "imagePath": "assets/close.png"},
      ],
      [
        {"title": AppLocalizations.of(context)!.jerking, "imagePath": "assets/jerking.png"},
        {"title": AppLocalizations.of(context)!.stiffness, "imagePath": "assets/Stiffness.png"},
        {"title": AppLocalizations.of(context)!.both, "imagePath": "assets/both.png"},
        {"title": AppLocalizations.of(context)!.cantTellOther, "imagePath": "assets/question.png"},
        {"title": AppLocalizations.of(context)!.none, "imagePath": "assets/close.png"},
      ],
      [
        {"title": AppLocalizations.of(context)!.allBodyJerking, "imagePath": "assets/AllBodyJerking.png"},
        {"title": AppLocalizations.of(context)!.legsJerking, "imagePath": "assets/cramp.png"},
        {"title": AppLocalizations.of(context)!.armJerking, "imagePath": "assets/ArmJerking.png"},
        {"title": AppLocalizations.of(context)!.cantTellOther, "imagePath": "assets/question.png"},
        {"title": AppLocalizations.of(context)!.none, "imagePath": "assets/close.png"},
      ],
      [
        {"title": AppLocalizations.of(context)!.allBodyStiffness, "imagePath": "assets/allBodyStiff.png"},
        {"title": AppLocalizations.of(context)!.legsStiffness, "imagePath": "assets/legsStiff.png"},
        {"title": AppLocalizations.of(context)!.armStiffness, "imagePath": "assets/ArmStifenees.png"},
        {"title": AppLocalizations.of(context)!.cantTellOther, "imagePath": "assets/question.png"},
        {"title": AppLocalizations.of(context)!.none, "imagePath": "assets/close.png"},

      ],
      [
        {"title": AppLocalizations.of(context)!.staring, "imagePath": "assets/Eyes.png"},
        {"title": AppLocalizations.of(context)!.eyesUp, "imagePath": "assets/eyes up.png"},
        {"title": AppLocalizations.of(context)!.eyesDown, "imagePath": "assets/eyes down.png"},
        {"title": AppLocalizations.of(context)!.eyesRolling, "imagePath": "assets/eyes rolling.png"},
        {"title": AppLocalizations.of(context)!.cantTellOther, "imagePath": "assets/question.png"},
        {"title": AppLocalizations.of(context)!.none, "imagePath": "assets/close.png"},
      ],
      [
        {"title": AppLocalizations.of(context)!.clapping, "imagePath": "assets/clapping.png"},
        {"title": AppLocalizations.of(context)!.walking, "imagePath": "assets/man-walking 1.png"},
        {"title": AppLocalizations.of(context)!.correr, "imagePath": "assets/runnnig.png"},
        {"title": AppLocalizations.of(context)!.lip, "imagePath": "assets/lip.png"},
        {"title": AppLocalizations.of(context)!.cantTellOther, "imagePath": "assets/question.png"},
        {"title": AppLocalizations.of(context)!.none, "imagePath": "assets/close.png"},
      ],
    ];

    cardTitles = [
      AppLocalizations.of(context)!.awareness,
      AppLocalizations.of(context)!.bodySeizure,
      AppLocalizations.of(context)!.movements,
      AppLocalizations.of(context)!.jerkingMovements,
      AppLocalizations.of(context)!.stiffness,
      AppLocalizations.of(context)!.eyes,
      AppLocalizations.of(context)!.movimento
    ];

    selections = [];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF8ECFF),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                cardTitles[currentIndex],
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).size.width / 160).floor(),
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                ),
                itemCount: cardSets[currentIndex].length,
                itemBuilder: (context, i) {
                  return QuizzCard(
                    title: cardSets[currentIndex][i]["title"]!,
                    imagePath: cardSets[currentIndex][i]["imagePath"]!,
                    onSelected: (title) => handleCardSelection(title),
                    opacity: isCardSelected && selectedCardTitle != null && selectedCardTitle != cardSets[currentIndex][i]["title"]! ? 0.5 : 1.0,
                  );
                },
              ),
            ),

            const SizedBox(height: 25.0),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
              value: (currentIndex + 1) / cardSets.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            ),
            const SizedBox(height: 25.0),
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
                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(color: Colors.black54),
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
        possibleTriggers: selections.sublist(9).join(', '),
        duration: selections[7],
        eventTime: selections[8],
        movimento: selections[6],
      );

      await FirebaseFirestore.instance.collection('seizureEvents').add(seizureEvent.toMap());
    }
  }
}
