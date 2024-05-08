import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tipo_treino/screens/mymeds_page.dart';


class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                          color: Colors.deepPurpleAccent,
                          Icons.email_outlined
                      ),

                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: TextFormField(

                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                          color: Colors.deepPurpleAccent,
                          Icons.lock_outline_rounded

                      ),

                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: ElevatedButton.icon(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => MedsPage()
                      ));
                },
                style: ElevatedButton.styleFrom(

                    backgroundColor: Color(0xC77DFF),
                    minimumSize: Size(double.infinity , 55),
                    textStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600, // Define o texto como negrito
                        fontSize: 16,
                      ),

                    )
                ),
                icon: Icon(Icons.navigate_next),
                label: Text("Sign In ",),

              ),
            )
          ],
        )
    );
  }
}

