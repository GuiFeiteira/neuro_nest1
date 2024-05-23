import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tipo_treino/screens/home_page.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  // Handle sign-in
  Future<void> _signIn() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save additional user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text,
        'date_of_birth': _dobController.text,
        'email': _emailController.text,
      });

      // HomePage on successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');
        // Show an error message to the user
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak. At least 6 digits');
        // Show an error message to the user
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
      // other exceptions
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
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    color: Colors.indigo,
                    Icons.person_outline,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                hintText: 'Date of Birth',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    color: Colors.indigo,
                    Icons.calendar_today_outlined,
                  ),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your date of birth';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    color: Colors.indigo,
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
                    color: Colors.indigo,
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
                if (_formKey.currentState!.validate()) {
                  await _signIn();
                }
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
