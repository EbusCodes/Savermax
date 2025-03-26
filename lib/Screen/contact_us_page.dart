import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactUsPage extends StatefulWidget {
  ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

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
        title: const Text('Contact Us'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Feel free to reach out to us!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(37, 211, 102, 1)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: 'Your Name', prefixIcon: Icon(Icons.abc)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Your Email Address',
                    prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                    labelText: 'Your Message...',
                    prefixIcon: Icon(Icons.message)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                onPressed: () {
                  if (emailController.text.isNotEmpty &&
                      nameController.text.isNotEmpty &&
                      messageController.text.isNotEmpty) {
                    Random random = Random();
                    int randomNumber = random.nextInt(1000000);
                    final user = FirebaseAuth.instance.currentUser;
                    FirebaseFirestore.instance
                        .collection('ContactUs')
                        .doc('${FirebaseAuth.instance.currentUser!.email}$randomNumber')
                        .set({
                      'UserID': user?.uid,
                      'Name': user?.displayName,
                      'Name Supplied': nameController.text,
                      'Email': FirebaseAuth.instance.currentUser?.email,
                      'Email Supplied': emailController.text,
                      'Time Contacted': FieldValue.serverTimestamp(),
                      'Message': messageController.text
                    });
                    messageController.clear();
                    emailController.clear();
                    nameController.clear();

                    showToast(
                        'Message Sent Successfully. We will get back to you shortly',
                        3,
                        Icons.check_circle,
                        const Color.fromRGBO(37, 211, 102, 1));
                  } else {
                    showToast(
                        "All fields are required", 3, Icons.info, Colors.red);
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
