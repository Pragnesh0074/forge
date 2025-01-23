import 'package:flutter/material.dart';

class OBPage1 extends StatefulWidget {
  const OBPage1({super.key});

  @override
  State<OBPage1> createState() => _OBPage1State();
}

class _OBPage1State extends State<OBPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/fire.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 32),
            const Text(
              'WELCOME',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 56,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Let's track your life",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
