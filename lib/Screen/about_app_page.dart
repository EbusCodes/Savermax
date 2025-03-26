import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/trans_app_icon.png', 
            color: const Color.fromRGBO(37, 211, 102, 1),
            width: 250,
            height: 250,
            ),
            const SizedBox(height: 5),
           const Text(
              'SaverMax',
              style: TextStyle(
                color: Color.fromRGBO(37, 211, 102, 1),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
           const SizedBox(height: 10),
           const Text(
              'Version 1.0.24.1',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            
          ],
        ),
      ),
    );
  }
}