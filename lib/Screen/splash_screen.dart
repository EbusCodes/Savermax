import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savermax/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (_) => const HomePage()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Launcher screen',
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
        body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'App icon',
              child: Image.asset('images/trans_app_icon.png',
              width: 280,
              height: 280,),
            ),
            const SizedBox(height: 100),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        )
        )
      ),
    );
  }
}
