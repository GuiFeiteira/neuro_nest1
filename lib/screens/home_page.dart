import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tipo_treino/components/moodOptionBar.dart';
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
  void _showProfileDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Profile Settings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(userName), // Display the user's name
              subtitle: const Text("View/Edit Profile"),
              onTap: () {
                // TODO: Navigate to profile editing screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Change Language"),
              onTap: () {
                // TODO: Implement language selection logic
              },
            ),
            // Add more options as needed (e.g., logout, settings)
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8ECFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String?>(
                  future: _getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          CircleAvatar(
                            //backgroundImage: AssetImage('assets/profile_picture.png'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Welcome Back, $userName",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,

                            ),
                          ),
                    GestureDetector(
                    onTap: () {
                      if (snapshot.hasData && snapshot.data != null) {
                          _showProfileDialog(context, snapshot.data!); // Show dialog if user data is available
                        }
                    },
                          child: CircleAvatar(
                            //backgroundImage: AssetImage('assets/profile_picture.png'),
                            radius: 30,
                          ),
                    ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 8),
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
                SleepOptionBar(),
                SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "Como te sentes hoje?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                MoodOptionBar()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarCustom(selectedIndex: 0,), // Use const for static widgets
    );
  }
}
