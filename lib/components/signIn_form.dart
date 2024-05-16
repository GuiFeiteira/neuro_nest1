import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tipo_treino/screens/home_page.dart';
import 'package:tipo_treino/screens/mymeds_page.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Handle sign-in logic
  Future<void> _signIn() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to MedsPage on successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // Show an error message to the user
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that email.');
        // Show an error message to the user
      }
    } catch (e) {
      print(e.toString());
      // Handle other exceptions
    } finally {
      _emailController.text = '';
      _passwordController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    color: Colors.deepPurpleAccent,
                    Icons.email_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    color: Colors.deepPurpleAccent,
                    Icons.lock_outline_rounded,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) { // Validate form fields
                  await _signIn(); // Call sign-in function
                }else{print('erro');}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xC77DFF),
                minimumSize: Size(double.infinity, 55),
                textStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600, // Bold text
                    fontSize: 16,
                  ),
                ),
              ),
              icon: Icon(Icons.navigate_next),
              label: Text("Sign In"),
            ),
          ),
        ],
      ),
    );
  }
}
