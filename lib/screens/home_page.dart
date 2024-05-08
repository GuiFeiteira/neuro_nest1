import 'package:flutter/material.dart';
import 'package:tipo_treino/components/sleep.dart';
import '../components/app_bar.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinhe os elementos nas extremidades
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
                ),
                SizedBox(height: 8), // Adicione espaço entre os elementos
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "Como dormiu hoje ?", // Texto adicional
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
