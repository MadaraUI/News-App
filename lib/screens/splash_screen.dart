import 'package:flutter/material.dart';
import 'package:mad_news/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Section
            Image.asset(
              'assets/news.png', 
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 10),
            
            // Title Section
            Text(
              "News App",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900
              ),
            ),
            const SizedBox(height: 30),

            // "Get Started" Button Section
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
