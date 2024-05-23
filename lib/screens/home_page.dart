import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tipo_treino/components/sleep.dart';
import '../components/app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String?> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc['name'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8ECFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String?>(
                  future: _getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/profile_picture.png'),
                            radius: 30,
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text('User not found');
                    } else {
                      String userName = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome Back, $userName",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/profile_picture.png'),
                            radius: 30,
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 8), // Adicione espaço entre os elementos
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "How did you sleep today ?",

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SleepOptionBar()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottonAppBar(), // Use const for static widgets
    );
  }
}
