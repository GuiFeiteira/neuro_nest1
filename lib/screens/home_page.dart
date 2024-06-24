import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipo_treino/components/moodOptionBar.dart';
import 'package:tipo_treino/components/sleep.dart';
import 'package:tipo_treino/screens/myProfile_page.dart';
import '../components/app_bar.dart';
import '../components/educational.dart';
import '../components/localProvider.dart';
import 'landing_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String?> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        String fullName = userDoc['name'];
        List<String> names = fullName.split(' ');
        return names.isNotEmpty ? names[0] : fullName;
      }
    }
    return null;
  }

  void _showProfileDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(AppLocalizations.of(context)!.profileSets)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(userName),
              subtitle: Text(AppLocalizations.of(context)!.analises),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => MyProfile()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.mudarLingua),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LandingPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(AppLocalizations.of(context)!.selectlanguage)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _changeLanguage(context, const Locale('en'));
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    'assets/english.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    _changeLanguage(context, const Locale('pt'));
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    'assets/portuguese.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8ECFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView( // Add SingleChildScrollView here
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
                          const CircleAvatar(
                            //backgroundImage: AssetImage('assets/profile_picture.png'),
                            radius: 30,
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('User not found');
                    } else {
                      String userName = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.welcomeback(userName),
                            style: const TextStyle(
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
                            child: const CircleAvatar(
                              //backgroundImage: AssetImage('assets/profile_picture.png'),
                              radius: 30,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                      AppLocalizations.of(context)!.sleepoption
                  ),
                ),
                SleepOptionBar(),
                const SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    AppLocalizations.of(context)!.howufell,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                MoodOptionBar(),
                SizedBox(height: 20.0),
                EducationalResources(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBarCustom(selectedIndex: 0),
    );
  }
}
