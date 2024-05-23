import 'dart:ui';
import 'package:sign_button/sign_button.dart';
import 'package:tipo_treino/screens/quizz_page.dart';
import '../components/anim_butt.dart';
import '../components/signIn_form.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late RiveAnimationController _btncontroller;

  @override
  void initState() {
    _btncontroller = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset("assets/new_file.riv"),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30,
                sigmaY: 20,
              ),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                children: [
                  SizedBox(
                    width: 260,
                    child: Column(
                      children: [
                        Text(
                          "NeuroNest",
                          style: GoogleFonts.permanentMarker(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Your Brain in The Cloud",
                          style: GoogleFonts.robotoMono(),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  AnimatedBtn(
                    btncontroller: _btncontroller,
                    press: () {
                      _btncontroller.isActive = true;
                      showGeneralDialog(
                        barrierDismissible: true,
                        barrierLabel: "Sign in",
                        context: context,
                        pageBuilder: (context, _, __) => Center(
                          child: Container(
                            height: 650,
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8ECFF).withOpacity(0.95),
                              borderRadius: const BorderRadius.all(Radius.circular(45)),
                            ),
                            child: Scaffold(
                              backgroundColor: Colors.transparent,
                              body: SingleChildScrollView( // Adicionado SingleChildScrollView
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0,top: 15),
                                      child: Text(
                                        "Sign In",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context).textTheme.displayLarge,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SignInForm(),
                                    const Row(
                                      children: [
                                        Expanded(child: Divider()),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                          child: Text(
                                            "OR",
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Divider()),
                                      ],
                                    ),
                                    Text(
                                      "Sign up with Google or Facebook",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 26),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SignInButton.mini(
                                            buttonSize: ButtonSize.medium,
                                            buttonType: ButtonType.facebook,
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) => QuizPage()));
                                            },
                                          ),
                                          SignInButton.mini(
                                            buttonSize: ButtonSize.medium,
                                            buttonType: ButtonType.google,
                                            onPressed: () {
                                              print('click');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
