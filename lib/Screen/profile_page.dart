// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:savermax/Provider/ref_provider.dart';
import 'package:savermax/config/user_auth.dart';
import 'package:savermax/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection('Users');
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController referralController = TextEditingController();
  late String imageURL;
  late Future<QuerySnapshot> _future;
  bool isDataChecked = false;
  bool isAccountChecked = false;

  late FToast fToast;
  @override
  void initState() {
    super.initState();
    _future = profileRef
        .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
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
    void uploadImage() async {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 100);

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('${FirebaseAuth.instance.currentUser!.email}${image!.path}');
      await ref.putFile(File(image.path));
      await ref.getDownloadURL().then((value) {
        setState(() {
          imageURL = value;
        });
        setState(() {});
      });
      final user = FirebaseAuth.instance.currentUser!;
      user.updatePhotoURL(imageURL);
      showToast(
        'Profile picture updated successfully',
        3,
        Icons.info,
        const Color.fromRGBO(37, 211, 102, 1),
      );
    }

    Future displayBottomSheet() {
      return showModalBottomSheet(
          context: context,
          isDismissible: true,
          barrierColor: Colors.black87.withOpacity(0.8),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          builder: ((context) {
            return Container(
                padding: const EdgeInsets.all(10),
                height: 80,
                width: double.infinity,
                child: TextButton(
                    onPressed: uploadImage,
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Upload Image from Gallery',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    )));
          }));
    }

    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return Consumer<ReferralProvider>(builder: (context, file, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_left)),
          title: const Text(
            'Profile',
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final token = await FirebaseMessaging.instance.getToken();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          elevation: 0,
                          title: const Text('Wait a sec!'),
                          content: SizedBox(
                            height: 250,
                            child: FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('FCMTokens')
                                    .where('FCMToken', isEqualTo: token)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Center(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.green))),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Center(
                                            child: Text(
                                                'Error: ${snapshot.error}')),
                                      ],
                                    );
                                  }
                                  final datas = snapshot.data?.docs;
                                  return SizedBox(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image(
                                              image: NetworkImage(FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.photoURL ??
                                                  'https://cobaltsettlements.com/wp-content/uploads/2019/03/blank-profile.jpg'),
                                              height: 100.0,
                                              fit: BoxFit.fill,
                                              width: 100.0,
                                              filterQuality:
                                                  FilterQuality.medium,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          FirebaseAuth.instance.currentUser
                                                  ?.displayName ??
                                              ' ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                            'Are you sure you want to logout?',
                                            textAlign: TextAlign.center),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 238, 70, 58)
                                                    // fixedSize: Size(250, 50),
                                                    ),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  datas!.forEach((element) {
                                                    final ids = element.id;
                                                    FirebaseFirestore.instance
                                                        .collection('FCMTokens')
                                                        .doc(ids)
                                                        .delete();
                                                  });
                                                  for (final providerProfile
                                                      in user!.providerData) {
                                                    if (providerProfile
                                                            .providerId ==
                                                        'google.com') {
                                                      provider
                                                          .googleLogout()
                                                          .whenComplete(() {
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const MyApp()),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                      });
                                                    } else {
                                                      provider
                                                          .emailLogout()
                                                          .whenComplete(() {
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const MyApp()),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                      });
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  "Continue",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        37, 211, 102, 1),
                                                  ),
                                                ),
                                              )
                                            ])
                                      ],
                                    ),
                                  );
                                }),
                          )));
                },
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green))),
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(child: Text('Error: ${snapshot.error}')),
                  ],
                );
              }
              final datum = snapshot.data?.docs[0];
              final refCode = datum?.get('RefCode');
              List referralList = datum?.get('Referrals');

              return RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return Future.delayed(const Duration(seconds: 2));
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// -- IMAGE
                      Stack(
                        children: [
                          SizedBox(
                              width: 120,
                              height: 120,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  user?.photoURL ??
                                      "https://cobaltsettlements.com/wp-content/uploads/2019/03/blank-profile.jpg",
                                ),
                              )),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color.fromRGBO(
                                          37, 211, 102, 1)),
                                  child: IconButton(
                                    onPressed: () {
                                      displayBottomSheet();
                                    },
                                    icon: Icon(Icons.edit,
                                        color: Colors.white, size: 20),
                                  )))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(FirebaseAuth.instance.currentUser?.displayName ?? "",
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      Text(FirebaseAuth.instance.currentUser?.email ?? "",
                          style: Theme.of(context).textTheme.bodyMedium),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: [
                          const SizedBox(height: 10),
                          const Text(
                              'Did someone refer you? Let us know and we\'ll send a tip! ',
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 20),
                          TextField(
                            controller: referralController,
                            decoration: InputDecoration(
                                hintText: "Referrer's code",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor:
                                    const Color.fromRGBO(37, 211, 102, 0.07),
                                filled: true,
                                prefixIcon:
                                    const Icon(Icons.person_2_outlined)),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(37, 211, 102, 1),
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              onPressed: () async {
                                if (referralController.text.isEmpty) {
                                  showToast('Referrer code cannot be empty', 3,
                                      Icons.info, Colors.red);
                                } else {
                                  CollectionReference emailRef =
                                      FirebaseFirestore.instance
                                          .collection('Users');
                                  final value = await emailRef
                                      .where('RefCode',
                                          isEqualTo:
                                              referralController.text.trim())
                                      .get();

                                  if (referralController.text.trim() ==
                                      refCode) {
                                    showToast('You cannot refer yourself', 4,
                                        Icons.info, Colors.red);
                                  } else if (value.docs.isEmpty) {
                                    showToast('Invalid referrer code', 4,
                                        Icons.info, Colors.red);
                                  } else if (value.docs.isNotEmpty) {
                                    Provider.of<ReferralProvider>(context,
                                            listen: false)
                                        .setRefferal(referralController.text);

                                    if (file.exists == true) {
                                      showToast(
                                          'Referral has already been added',
                                          4,
                                          Icons.info,
                                          Colors.red);
                                    } else if (file.exists == false) {
                                      showToast(
                                          'Referrer code submitted! User will be rewarded shortly',
                                          4,
                                          Icons.check_circle,
                                          const Color.fromRGBO(
                                              37, 211, 102, 1));
                                      referralController.clear();
                                    }
                                  }
                                }
                              },
                              child: const Text('Submit',
                                  style: TextStyle(color: Colors.white))),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      ListTile(
                          title: const Text('Your Referral Code'),
                          subtitle: Text("$refCode",
                              style: Theme.of(context).textTheme.bodyMedium),
                          trailing: IconButton(
                            onPressed: () {
                              ClipboardData data =
                                  ClipboardData(text: "$refCode");
                              Clipboard.setData(data);
                              showToast(
                                  'Copied to clipboard!',
                                  2,
                                  Icons.check_circle,
                                  const Color.fromRGBO(37, 211, 102, 1));
                            },
                            icon: const Icon(Icons.copy),
                          )),
                      const SizedBox(height: 10),

                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                'Unlock Earnings Together! 🌟 Share the joy of SaverMax with your friends and family. Invite them using your unique referral code and boost your earnings 🚀 Spread the love, share the benefits! The more you share, the more you earn. Share now and let the rewards roll in! ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                  onPressed: () {
                                    String shareLink =
                                        'Hey there! Signup on SaverMax; a status saver app using my referral code $refCode and stand a chance to win amazing prizes! Click here to download now https://play.google.com/store/apps/details?id=com.savermax';
                                    Share.share(shareLink);
                                  },
                                  child: const Center(
                                      child: Text(
                                    'Share Referral Code',
                                    style: TextStyle(
                                        color: Color.fromRGBO(37, 211, 102, 1),
                                        fontSize: 17),
                                  )))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Your Referrals',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text('${referralList.length}')
                                  ]),
                              const SizedBox(height: 15),
                              Center(
                                  child: referralList.isEmpty
                                      ? Text(
                                          'You do not have any referrals yet')
                                      : Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Column(
                                                  children: List.generate(
                                                      referralList.length,
                                                      (index) {
                                                final data =
                                                    referralList[index];
                                                return Container(
                                                  height: 50,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      child:
                                                          Text("${index + 1}"),
                                                    ),
                                                    title: Text(data),
                                                  ),
                                                );
                                              })),
                                            ],
                                          ),
                                        ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account Deletion',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Please kindly submit a request if you want all your data and information in our database to be deleted. This action is irreversible and will take effect within 90 days of request, we will notify you via email when your data has been successfully deleted',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CheckboxListTile(
                                title: Text('Delete Account',
                                    style: TextStyle(color: Colors.red)),
                                subtitle: Text(
                                    'deletes your authentication information'),
                                value: isAccountChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    isAccountChecked = newValue!;
                                  });
                                },
                                activeColor: Color.fromRGBO(37, 211, 102, 1),
                                checkColor: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              CheckboxListTile(
                                  title: Text('Delete Data',
                                      style: TextStyle(color: Colors.red)),
                                  subtitle: Text(
                                      'deletes all generated data linked to your account from our database'),
                                  value: isDataChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isDataChecked = newValue!;
                                    });
                                  },
                                  activeColor: Color.fromRGBO(37, 211, 102, 1),
                                  checkColor: Colors.white),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 241, 68, 68),
                                      side: BorderSide.none,
                                      shape: const StadiumBorder()),
                                  onPressed:
                                      isAccountChecked == false ||
                                              isDataChecked == false
                                          ? null
                                          : () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                          elevation: 0,
                                                          title: const Text(
                                                            'Warning!',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          content: SizedBox(
                                                            height: 130,
                                                            child: Column(
                                                              children: [
                                                                const Text(
                                                                    'This is an irreversible action, are you sure you want to proceed?',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                const SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(),
                                                                        style: ElevatedButton.styleFrom(
                                                                            elevation:
                                                                                0,
                                                                            backgroundColor: Color.fromRGBO(
                                                                                37,
                                                                                211,
                                                                                102,
                                                                                1)
                                                                            // fixedSize: Size(250, 50),
                                                                            ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            SizedBox(width: 5),
                                                                            const Text(
                                                                              "Cancel",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                            SizedBox(width: 5),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection('AccountDeletion')
                                                                              .doc('${FirebaseAuth.instance.currentUser!.email}')
                                                                              .set({
                                                                            'Name':
                                                                                FirebaseAuth.instance.currentUser?.displayName,
                                                                            'Email Address':
                                                                                FirebaseAuth.instance.currentUser?.email,
                                                                            'UserID':
                                                                                FirebaseAuth.instance.currentUser?.uid,
                                                                            'Time':
                                                                                FieldValue.serverTimestamp(),
                                                                            'Request':
                                                                                'Delete all user data and information'
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          setState(
                                                                              () {
                                                                            isAccountChecked =
                                                                                false;
                                                                            isDataChecked =
                                                                                false;
                                                                          });
                                                                          showToast(
                                                                              'Request submitted. Your account will be deleted with 90 days, kindly logout of your account while we effect the changes',
                                                                              6,
                                                                              Icons.info,
                                                                              Color.fromRGBO(37, 211, 102, 1));
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "Delete",
                                                                          style:
                                                                              TextStyle(color: Color.fromARGB(255, 238, 70, 58)),
                                                                        ),
                                                                      )
                                                                    ])
                                                              ],
                                                            ),
                                                          )));
                                            },
                                  child: const Text('Delete Account',
                                      style: TextStyle(color: Colors.white))),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }
}
