import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savermax/Screen/login_page.dart';


class WarningPage extends StatelessWidget {
  const WarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, color: Colors.red,
            size: 90,),
            const SizedBox(height: 20),
            const Text(
              'You need to sign in to your account to access this page',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 35),
            TextButton(
              onPressed: () {
 Navigator.push(
                context, CupertinoPageRoute(builder: (_) =>  const LoginPage()));
              },
              child: const Text('Sign In', style: TextStyle(color: Color.fromRGBO(37, 211, 102, 1)
              ,fontSize: 20),
            ),
            ),
  ]),
      ),
    );
  }
}