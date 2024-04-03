import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class QuizzCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const QuizzCard({
    required this.title,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 250,
          decoration: ShapeDecoration(
            color: Color(0xFFB7B7B7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 9,
                offset: Offset(-8, 6),
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Inter',
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, right: 3, left: 5),
                    child: Image.asset(
                      imagePath,
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
