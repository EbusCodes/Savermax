// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  final textFieldFocusNode1 = FocusNode();
  bool _obscured1 = true;

  void _toggleObscured1() {
    setState(() {
      _obscured1 = !_obscured1;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

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
      
    void showCustomDialog(BuildContext context) => showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            child: Container(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Thank you for using SaverMax. Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use SaverMax. Please read this Privacy Policy carefully and if you do not agree with the terms of this Privacy Policy, please do not access the App.',
                        style: TextStyle(fontSize: 13)),
                    SizedBox(height: 10),
                    Text('1. Information We Collect',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      'We may collect personal identification information from Users in a variety of ways, including, but not limited to, when Users visit our App, register on the App, subscribe to the newsletter, respond to a survey, fill out a form, and in connection with other activities, services, features, or resources we make available on SaverMax. Users may be asked for, as appropriate, name, email address, mailing address, and phone number, in some instances users may be required to upload their profile photos',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '2. How We Use Collected Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'We may collect and use Users personal information for the following purposes:',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'a. To improve customer service: Information you provide helps us respond to your customer service requests and support needs more efficiently.',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'b. To personalize user experience: We may use information in the aggregate to understand how our Users as a group use the services and resources provided on SaverMax.',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'c. To improve SaverMax: We may use feedback you provide to improve our products and services.',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'd. To send periodic emails: We may use the email address to send User information and updates pertaining to their order. It may also be used to respond to their inquiries, questions, and/or other requests.',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '3. How We Protect Your Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'We adopt appropriate data collection, storage, and processing practices and security measures to protect against unauthorized access, alteration, disclosure, or destruction of your personal information, username, password, transaction information, and data collected and stored on SaverMax.',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '4. Sharing Your Personal Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'We do not sell, trade, or rent Users personal identification information to others. We may share generic aggregated demographic information not linked to any personal identification information regarding visitors and users with our business partners, trusted affiliates, and advertisers for the purposes outlined above.',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '5. Compliance with Children\'s Online Privacy Protection Act',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Protecting the privacy of the very young is especially important. For that reason, we never collect or maintain information on SaverMax from those we actually know are under 13, and no part of SaverMax  is structured to attract anyone under 13.',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '6. Changes to This Privacy Policy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'We have the discretion to update this Privacy Policy at any time. When we do, we will revise the updated date at the bottom of this page. We encourage Users to frequently check this page for any changes to stay informed about how we are helping to protect the personal information we collect. You acknowledge and agree that it is your responsibility to review this Privacy Policy periodically and become aware of modifications.',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '7. Your Acceptance of These Terms',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'By using SaverMax, you signify your acceptance of this Privacy Policy. If you do not agree to this Privacy Policy, please do not use SaverMax. Your continued use of the SaverMax following the posting of changes to this Privacy Policy will be deemed your acceptance of those changes.',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Column(
                        children: [
                          Text('Read and understood?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          SizedBox(height: 5),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(37, 211, 102, 1),
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              onPressed:  () {
                                      Navigator.of(context).pop();
                                    },
                              child: const Text('Continue',
                                  style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(""),
        backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                      'You made the right choice. Kindly proceed to create your account now!'),
                  SizedBox(height: 30.0),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: "Full Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(37, 211, 102, 0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.contains('@') == false ||
                            value.contains('.') == false) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      focusNode: textFieldFocusNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: const Color.fromRGBO(37, 211, 102, 0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: GestureDetector(
                            onTap: _toggleObscured,
                            child: Icon(
                              _obscured
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      obscureText: _obscured,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Password mismatch!';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: textFieldFocusNode1,
                      controller: passwordConfirmController,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: const Color.fromRGBO(37, 211, 102, 0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: GestureDetector(
                            onTap: _toggleObscured1,
                            child: Icon(
                              _obscured1
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      obscureText: _obscured1,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 35.0),
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (passwordConfirmController.text ==
                              passwordController.text ||
                          nameController.text.isNotEmpty) {
                        final refCode = Random().nextInt(1000000000).toString();
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          await FirebaseAnalytics.instance
                              .logEvent(name: 'sign_up');
                          FirebaseAuth.instance.currentUser
                              ?.updateDisplayName(nameController.text);

                          FirebaseFirestore.instance
                              .collection('FilePath')
                              .doc(
                                  '${FirebaseAuth.instance.currentUser!.email}')
                              .set({
                            'UserID': FirebaseAuth.instance.currentUser?.uid,
                            'Email': FirebaseAuth.instance.currentUser?.email,
                            'Name':
                                FirebaseAuth.instance.currentUser?.displayName,
                            'Files': <String>[]
                          });
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(
                                  '${FirebaseAuth.instance.currentUser!.email}')
                              .set({
                            'UserID': FirebaseAuth.instance.currentUser?.uid,
                            'Name': nameController.text,
                            'Email': emailController.text.trim(),
                            'Account Created': FieldValue.serverTimestamp(),
                            'RefEarnings': 0,
                            'Referrals': <String>[],
                            'RefCode': refCode
                          });
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification();
                          showToast(
                              'Account Created Successfully! Kindly proceed to login',
                              5,
                              Icons.check_circle,
                              const Color.fromRGBO(37, 211, 102, 1));
                          Navigator.of(context).pop();
                        } on FirebaseAuthException catch (error) {
                          if (error.code == 'email-already-in-use') {
                            showToast(
                                'User already exists! Kindly return to login page or reset your password',
                                5,
                                Icons.info,
                                Colors.red);
                          }
                          if (error.code == 'invalid-email') {
                            showToast(
                                'Invalid email address! Check your email address and try again',
                                3,
                                Icons.info,
                                Colors.red);
                          } else if (error.code == 'weak-password') {
                            showToast(
                                'Weak password. Password must be a least 6 characters long',
                                3,
                                Icons.info,
                                Colors.red);
                          }
                        }
                      } else {
                        showToast(
                            'Username cannot be blank or password mismatch',
                            3,
                            Icons.info,
                            Colors.red);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('By continuing, you agree to our'),
                  TextButton(
                      onPressed: () {
                        showCustomDialog(context);
                      },
                      child: Text('Privacy Policy',
                          style: TextStyle(
                              color: Color.fromRGBO(37, 211, 102, 1))))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
