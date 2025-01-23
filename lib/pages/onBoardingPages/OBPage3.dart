import 'package:flutter/material.dart';

class OBPage3 extends StatefulWidget {
  const OBPage3({super.key});

  @override
  State<OBPage3> createState() => _OBPage3State();
}

class _OBPage3State extends State<OBPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/calendar.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 32),
            const Text(
              'EVERYDAY',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 56,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Starting today!",
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
