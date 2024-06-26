import 'dart:ui';
import 'package:tipo_treino/components/signUp_form.dart';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedBtn(
                        label: "Sign In",
                        btncontroller: _btncontroller,
                        press: () {
                          _btncontroller.isActive = true;
                          showGeneralDialog(
                            barrierDismissible: true,
                            barrierLabel: "Sign in",
                            context: context,
                            pageBuilder: (context, _, __) => Center(
                              child: Container(
                                height: 530,
                                margin: const EdgeInsets.symmetric(horizontal: 40),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8ECFF).withOpacity(0.95),
                                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                                ),
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: SingleChildScrollView(
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      AnimatedBtn(
                        label: "Sign Up",
                        btncontroller: _btncontroller,
                        press: () {
                          _btncontroller.isActive = true;
                          showGeneralDialog(
                            barrierDismissible: true,
                            barrierLabel: "Sign Up",
                            context: context,
                            pageBuilder: (context, _, __) => Center(
                              child: Container(
                                height: 430,
                                margin: const EdgeInsets.symmetric(horizontal: 40),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8ECFF).withOpacity(0.95),
                                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                                ),
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0,top: 15),
                                          child: Text(
                                            "Sign Up",
                                            style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context).textTheme.displayLarge,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SignUpForm(),


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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
