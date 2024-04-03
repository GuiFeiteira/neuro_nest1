import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    Key? key,
    required RiveAnimationController btncontroller,
    required this.press,
  })  : _btncontroller = btncontroller,
        super(key: key);

  final RiveAnimationController _btncontroller;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 64,
        width: 260,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/button (3).riv",
              controllers: [_btncontroller],
            ),
            Positioned.fill(

              top: 00,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.arrow_down_right),
                  SizedBox(width: 4),
                  Text(
                    "Let's Start",
                    style: TextStyle(fontWeight: FontWeight.w600),
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

class Line8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 17.32,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2.0,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFF9D4EDD),

              ),
            ),
          ),
        ),
      ],
    );
  }
}