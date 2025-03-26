import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FPasswordPage extends StatefulWidget {
  const FPasswordPage({super.key});

  @override
  State<FPasswordPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<FPasswordPage> {
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  showToast(String message, int time, IconData icon, Color color) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 12.0,
          ),
          SizedBox(
            width: 200,
            child: Text(
              message,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: time),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        foregroundColor: Colors.white,
        elevation: 20,
        title: const Text(""),
        backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_header(context), _inputField(context)],
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Forgot Password?",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),
        Text('No worries! We\'ll help you get back in'),
        SizedBox(height: 15)
      ],
    );
  }

  _inputField(context) {
    TextEditingController emailController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromRGBO(37, 211, 102, 0.1),
              filled: true,
              prefixIcon: const Icon(Icons.email)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            CollectionReference emailRef =
                FirebaseFirestore.instance.collection('Users');
            final value = await emailRef
                .where('Email', isEqualTo: emailController.text.trim())
                .get();
            if (value.docs.isNotEmpty) {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: emailController.text.trim())
                  .whenComplete(() {
                showToast(
                    'A link to reset your password has been sent successfully to your email address!',
                    5,
                    Icons.check_circle,
                    const Color.fromRGBO(37, 211, 102, 1));
              });
            } else {
              showToast('Invalid email or user not found in database...', 3,
                  Icons.info, Colors.red);
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
          ),
          child: const Text(
            "Reset Password",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }
}
