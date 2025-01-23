import 'package:flutter/material.dart';

class OBPage2 extends StatefulWidget {
  const OBPage2({super.key});

  @override
  State<OBPage2> createState() => _OBPage2State();
}

class _OBPage2State extends State<OBPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/complete.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 32),
            const Text(
              'COMPLETE',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 56,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "One habit at a time",
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