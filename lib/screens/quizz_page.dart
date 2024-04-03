import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/quizz_card.dart';



class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8ECFF),
      appBar: AppBar(
        title: Text('Event Report'),
      ),
      body: Center(

        child: ListView(

          shrinkWrap: true,
          children: [
            Text("Awareness",
            ),


            SizedBox(height: 20), // Espaçamento acima da lista
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuizzCard(
                  title: "Fully Aware",
                  imagePath: "assets/fully aware.png",
                ),
                QuizzCard(
                  title: "Confused",
                  imagePath: "assets/confused.png",
                ),
              ],
            ),
            SizedBox(height: 40), // Espaçamento entre linhaas de cartões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuizzCard(
                  title: "Responds to Voice",
                  imagePath: "assets/Responds_voice.png",
                ),
                QuizzCard(
                  title: "Not Responsive",
                  imagePath: "assets/surprised.png",
                ),
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(

                children: [
                  TextButton(
                    onPressed: () {

                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                        Text(
                          "Back",
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {

                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: Row(
                      children: [

                        // Espaçamento entre o ícone e o texto
                        Text(
                          "Next",
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),

                  ),
                ],
              ),
            )

          ],

        ),
      ),
    );
  }
}
