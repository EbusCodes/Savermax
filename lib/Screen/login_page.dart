import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:savermax/Screen/forgot_password_page.dart';
import 'package:savermax/Screen/signup_page.dart';
import 'package:savermax/config/user_auth.dart';
import 'package:savermax/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
      bool haveRead = false;
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

  Future displayBottomSheet(ImageProvider image) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        barrierColor: Colors.black87.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
        builder: ((context) {
          final user = FirebaseAuth.instance.currentUser;
          return Container(
              padding: const EdgeInsets.all(20),
              height: 300,
              width: double.infinity,
              child: Column(
                children: [
                  Center(
                    child: Lottie.asset('images/welcome_animation.json',
                        height: 20),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: image,
                      height: 100.0,
                      fit: BoxFit.fill,
                      width: 100.0,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    user!.displayName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  const Text('You are now signed in!',
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MyApp()),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                          color: Color.fromRGBO(37, 211, 102, 1),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15)
                ],
              ));
        }));
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
      context: context,
      barrierDismissible: false,
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
                          Text('Read and understood?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 5),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(37, 211, 102, 1),
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              onPressed: () {
                                      Navigator.of(context).pop();
                                      haveRead = false;
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


    return Consumer<GoogleSignInProvider>(builder: (context, file, child) {
      return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(""),
            backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
            centerTitle: true,
          ),
          body: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Column(
                  children: [
                    Text(
                      "Welcome back!",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text("Kindly enter your credentials to login"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.contains('@') == false ||
                              value.contains('.') == false) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      focusNode: textFieldFocusNode,
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
                            padding: const EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(_obscured
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                            ),
                          )),
                      obscureText: _obscured,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim());

                            CollectionReference fcmtokenRef = FirebaseFirestore
                                .instance
                                .collection('FCMTokens');
                            final token =
                                await FirebaseMessaging.instance.getToken();
                            final tokenValue = await fcmtokenRef
                                .where('FCMToken', isEqualTo: token)
                                .get();
                            await FirebaseAnalytics.instance
                                .logEvent(name: 'login');

                            displayBottomSheet(const NetworkImage(
                                'https://cobaltsettlements.com/wp-content/uploads/2019/03/blank-profile.jpg'));

                            if (tokenValue.docs.isEmpty) {
                              Random random = Random();
                              int randomNumber = random.nextInt(1000000);
                              FirebaseFirestore.instance
                                  .collection('FCMTokens')
                                  .doc(
                                      '${FirebaseAuth.instance.currentUser!.email}$randomNumber')
                                  .set({
                                "UserID":
                                    FirebaseAuth.instance.currentUser?.uid,
                                "Name": FirebaseAuth
                                    .instance.currentUser?.displayName,
                                "Email":
                                    FirebaseAuth.instance.currentUser?.email,
                                "FCMToken": token,
                                'Signed in': FieldValue.serverTimestamp()
                              });
                            }
                          } on FirebaseAuthException catch (error) {
                            if (error.code == 'invalid-email') {
                              showToast(
                                  'Invalid email address! Check your email address and try again',
                                  3,
                                  Icons.info,
                                  Colors.red);
                            } else if (error.code == 'invalid-credential') {
                              showToast(
                                  'Invalid Credentials. Please check your details and try again',
                                  3,
                                  Icons.info,
                                  Colors.red);
                            } else if (error.code == 'wrong-password') {
                              showToast(
                                  'Invalid password. Please check and try again',
                                  3,
                                  Icons.info,
                                  Colors.red);
                            } else if (error.code == 'user-not-found') {
                              showToast(
                                  'User not found. Consider creating a new account instead',
                                  3,
                                  Icons.info,
                                  Colors.red);
                            }
                          }
                        } else {
                          showToast('Email and password are required', 3,
                              Icons.info, Colors.red);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(child: Text("Or")),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color.fromRGBO(37, 211, 102, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () async {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            await provider.googleLogin().whenComplete(() {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                displayBottomSheet(
                                    NetworkImage(user.photoURL ?? ''));
                                FirebaseAnalytics.instance
                                    .logEvent(name: 'login');
                              }

                              if (file.error == true) {
                                showToast('An error has occured', 3, Icons.info,
                                    Colors.red);
                              } else if (file.error1 == true) {
                                showToast(
                                    'This user has been banned from SaverMax',
                                    3,
                                    Icons.info,
                                    Colors.red);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/google_icon.png', 
                              height: 30,
                              filterQuality: FilterQuality.medium),
                              const SizedBox(width: 18),
                              const Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(37, 211, 102, 1),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const FPasswordPage()));
                      },
                      child: const Text(
                        "Forgot password",
                        style: TextStyle(
                          color: Color.fromRGBO(37, 211, 102, 1),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Dont have an account? "),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => const SignupPage()));
                            },
                            child: const Text(
                              "Sign Up With Email",
                              style: TextStyle(
                                  color: Color.fromRGBO(37, 211, 102, 1)),
                            ))
                      ],
                    ),
                  ],
                ),
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
          ));
    });
  }

 
}
