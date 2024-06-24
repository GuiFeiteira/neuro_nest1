import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizzCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final Function(String) onSelected;
  final double opacity;


  const QuizzCard({
    required this.title,
    required this.imagePath,
    required this.onSelected,
    required this.opacity,
    Key? key,
  }) : super(key: key);

  @override
  State<QuizzCard> createState() => _QuizzCardState();

}


class _QuizzCardState extends State<QuizzCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        await Future.delayed(const Duration(milliseconds: 20));
        widget.onSelected(widget.title);
        setState(() {
          isLoading = false;
        });
      },
      child: Opacity(
        opacity: widget.opacity,
        child: Container(
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
                offset: Offset(-5, 5),
                spreadRadius: 2,
              )
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      widget.title,
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
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, right: 3, left: 5),
                        child: Image.asset(
                          widget.imagePath,
                          width: 100,
                          height: 100,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isLoading
                  ? Container(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
