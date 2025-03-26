// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:savermax/Provider/ads_provider.dart';
import 'package:savermax/Screen/more_information.dart';
import 'package:savermax/Screen/redeem_history.dart';
import 'package:savermax/config/ads_id.dart';

class ReedemPoint extends StatefulWidget {
  const ReedemPoint({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  LoginState createState() => LoginState();
}

class LoginState extends State<ReedemPoint> {
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection('Users');
  TextEditingController addressController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController networkController = TextEditingController();
  late FToast fToast;
  late Stream<QuerySnapshot> _stream;
  String? phoneNumber;
  String? onlyPhone;
  String nation = "Select your country*";
  String countryCode = '';
  String country1Code = '';
  CollectionReference airtimeRef =
      FirebaseFirestore.instance.collection('AirtimeUnits');
  CollectionReference redeemRef =
      FirebaseFirestore.instance.collection('RedeemHistory');

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    _stream = FirebaseFirestore.instance.collection('GiftItems').snapshots();
    fToast.init(context);
    Provider.of<AdsProvider>(context, listen: false).loadRewardedAd();
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
    Future<void> handleRefresh() async {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {});
      showToast('Refresh completed', 5, Icons.check_circle,
          const Color.fromRGBO(37, 211, 102, 1));
      setState(() {});
    }

    return Consumer<AdsProvider>(builder: (context, file, child) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                color: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => const MoreInformationPage()))),
            IconButton(
              icon: const Icon(Icons.history),
              color: Colors.white,
              onPressed: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (_) => const RedeemHistory())),
            ),
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: profileRef
                .where('UserID',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .get(),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs[0];
              final referralEarnings = data?.get('RefEarnings');
              return Container(
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(37, 211, 102, 1)),
                child: LiquidPullToRefresh(
                  height: 110,
                  color: const Color.fromRGBO(37, 211, 102, 1),
                  backgroundColor: Colors.white,
                  onRefresh: handleRefresh,
                  animSpeedFactor: 3,
                  showChildOpacityTransition: false,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Center(
                          child: Text(
                            'My Max',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: Text(
                            '$referralEarnings',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 50),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 242, 239, 239),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50)),
                            ),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Card(
                                      color:
                                          const Color.fromRGBO(37, 211, 102, 1),
                                      shadowColor: Colors.black,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const SizedBox(
                                                width: 110,
                                                child: Text(
                                                  'Want to earn more Max???',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  showToast(
                                                      'Ad is being loaded, please wait...',
                                                      2,
                                                      Icons.check_circle,
                                                      const Color.fromRGBO(
                                                          37, 211, 102, 1));

                                                  await Provider.of<
                                                              AdsProvider>(
                                                          context,
                                                          listen: false)
                                                      .showRewardedAd();
                                                  if (file.rewardedDismissed ==
                                                      true) {
                                                    showToast(
                                                        'Reward added successfully!',
                                                        5,
                                                        Icons.check_circle,
                                                        const Color.fromRGBO(
                                                            37, 211, 102, 1));
                                                  } else if (file
                                                          .rewardedFailed ==
                                                      true) {
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 3));

                                                    showToast(
                                                        'Ad failed to load... Please try again later',
                                                        2,
                                                        Icons.check_circle,
                                                        Colors.red);
                                                  }
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons
                                                        .video_collection_outlined),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text('Watch ads!')
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://firebasestorage.googleapis.com/v0/b/savermax-8754d.appspot.com/o/banner.png?alt=media&token=0f31d089-9908-4924-807f-f624738781db'))))),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: _stream,
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
                                                                    Color>(
                                                                Colors.green))),
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

                                          List featuredList = [];
                                          snapshot.data!.docs
                                              .forEach((element) {
                                            final title = element.get('Title');
                                            final imageURL =
                                                element.get('Image');
                                            final maxPoints =
                                                element.get('MaxPoints');
                                            final redeemPoints =
                                                element.get('RedeemPoints');

                                            List<Map<String, dynamic>> details =
                                                [
                                              {
                                                'title': title,
                                                'imageURL': imageURL,
                                                'maxPoints': maxPoints,
                                                'redeemPoints': redeemPoints,
                                              }
                                            ];
                                            featuredList.add(details);
                                          });
                                          final userValues =
                                              featuredList.asMap();
                                          return GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              mainAxisExtent: 275,
                                            ),
                                            itemCount: userValues.length,
                                            itemBuilder: (_, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    16.0,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                16.0),
                                                        topRight:
                                                            Radius.circular(
                                                                16.0),
                                                      ),
                                                      child: Image.network(
                                                        "${userValues[index][0]['imageURL']}",
                                                        height: 140,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 5, 10, 0),
                                                      child: Text(
                                                        '${userValues[index][0]['maxPoints']} Max',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 5, 10, 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 40,
                                                            child: Text(
                                                              "${userValues[index][0]['title']}",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 3.0,
                                                          ),
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        elevation:
                                                                            0,
                                                                        backgroundColor: const Color
                                                                            .fromRGBO(
                                                                            37,
                                                                            211,
                                                                            102,
                                                                            1)),
                                                                    onPressed:
                                                                        () async {
                                                                      if (await referralEarnings >=
                                                                          userValues[index][0]
                                                                              [
                                                                              'redeemPoints']) {
                                                                        if (userValues[index][0]['title'] ==
                                                                            'NGN200 Airtime') {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) => StreamBuilder<QuerySnapshot>(
                                                                                  stream: airtimeRef.where('Balance', isGreaterThan: -1).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    final data1 = snapshot.data?.docs[0];
                                                                                    final balance = data1?.get('Balance');
                                                                                    return AlertDialog(
                                                                                      elevation: 0,
                                                                                      backgroundColor: Colors.white,
                                                                                      title: const Text('Submit Request'),
                                                                                      content: SingleChildScrollView(
                                                                                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Center(child: SizedBox(height: 200, width: double.infinity, child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), image: DecorationImage(image: NetworkImage('${userValues[index][0]['imageURL']}')))))),
                                                                                            const SizedBox(
                                                                                              height: 15,
                                                                                            ),
                                                                                            Text('You are about to redeem ${userValues[index][0]['title']} for ${userValues[index][0]['maxPoints']} Max. Please note that Non-Nigerians are not eligibe for this prize'),
                                                                                            const SizedBox(height: 15),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                const Text('Slots left', style: TextStyle(color: Colors.black)),
                                                                                                Text('$balance/1000', style: const TextStyle(color: Colors.red))
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(height: 15),
                                                                                            IntlPhoneField(
                                                                                              decoration: const InputDecoration(
                                                                                                fillColor: Color.fromRGBO(37, 211, 102, 0.07),
                                                                                                filled: true,
                                                                                                labelText: 'Phone*',
                                                                                                border: OutlineInputBorder(
                                                                                                  borderSide: BorderSide.none,
                                                                                                ),
                                                                                              ),
                                                                                              initialCountryCode: 'NG',
                                                                                              onChanged: (phone) {
                                                                                                country1Code = phone.countryCode;
                                                                                                onlyPhone = phone.number;
                                                                                                phoneNumber = phone.completeNumber;
                                                                                              },
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            TextField(
                                                                                              keyboardType: TextInputType.text,
                                                                                              controller: networkController,
                                                                                              decoration: InputDecoration(hintText: "Network*", border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none), fillColor: const Color.fromRGBO(37, 211, 102, 0.07), filled: true, prefixIcon: const Icon(Icons.satellite_alt_outlined)),
                                                                                            ),
                                                                                            const SizedBox(height: 20),
                                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.of(context).pop(),
                                                                                                child: const Text(
                                                                                                  "Cancel",
                                                                                                  style: TextStyle(color: Colors.red),
                                                                                                ),
                                                                                              ),
                                                                                              ElevatedButton(
                                                                                                onPressed: () async {
                                                                                                  if (onlyPhone != null && networkController.text.isNotEmpty && balance > 0 && country1Code == '+234') {
                                                                                                    CollectionReference profileRef = FirebaseFirestore.instance.collection('Users');

                                                                                                    final value = await profileRef.where('UserID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
                                                                                                    if (value.docs.isNotEmpty) {
                                                                                                      Random random = Random();
                                                                                                      int randomNumber = random.nextInt(1000000);
                                                                                                      final data = value.docs[0];
                                                                                                      final body = {
                                                                                                        'RefEarnings': data.get('RefEarnings') - userValues[index][0]['redeemPoints']
                                                                                                      };
                                                                                                      final airtimebody = {'Balance': balance - 1};

                                                                                                      await profileRef.doc(data.id).update(body);
                                                                                                      await FirebaseFirestore.instance.collection('AirtimeRequests').doc('${FirebaseAuth.instance.currentUser!.email}').collection('Requests')
                                                                                                        ..doc('${FirebaseAuth.instance.currentUser!.email}$randomNumber').set({
                                                                                                          'Name': FirebaseAuth.instance.currentUser?.displayName,
                                                                                                          'Email Address': FirebaseAuth.instance.currentUser?.email,
                                                                                                          'Item': userValues[index][0]['title'],
                                                                                                          'Max Spent': userValues[index][0]['redeemPoints'],
                                                                                                          'Balance': data.get('RefEarnings') - userValues[index][0]['redeemPoints'],
                                                                                                          'Phone Number': phoneNumber,
                                                                                                          'Netwrok': networkController.text,
                                                                                                          'Phone': onlyPhone,
                                                                                                          'OrderID': randomNumber,
                                                                                                          'UserID': FirebaseAuth.instance.currentUser?.uid,
                                                                                                          'Country Code': country1Code,
                                                                                                          'Time': FieldValue.serverTimestamp()
                                                                                                        });
                                                                                                      await FirebaseFirestore.instance.collection('RedeemHistory').doc('${FirebaseAuth.instance.currentUser!.email}').collection('Redeemed').add({
                                                                                                        'Account Name': FirebaseAuth.instance.currentUser?.displayName,
                                                                                                        'Email Address': FirebaseAuth.instance.currentUser?.email,
                                                                                                        'ItemName': userValues[index][0]['title'],
                                                                                                        'Point': userValues[index][0]['redeemPoints'],
                                                                                                        'Time': DateFormat('K:mm a, EEE - M/d/yy').format(DateTime.now()),
                                                                                                        'Image': userValues[index][0]['imageURL'],
                                                                                                        'OrderID': randomNumber,
                                                                                                        'UserID': FirebaseAuth.instance.currentUser?.uid,
                                                                                                        'Status': 'Pending',
                                                                                                        'created': Timestamp.now(),
                                                                                                        'Reason': 'Please check back later'
                                                                                                      });
                                                                                                      await airtimeRef.doc(data1!.id).update(airtimebody);

                                                                                                      networkController.clear();

                                                                                                      Navigator.of(context).pop();
                                                                                                      showToast('Request submitted successfully! We will reach out to you shortly', 5, Icons.check_circle, const Color.fromRGBO(37, 211, 102, 1));
                                                                                                      setState(() {});
                                                                                                    }
                                                                                                  } else if (balance <= 0) {
                                                                                                    Navigator.of(context).pop();
                                                                                                    showToast('There are no more available slots for airtime redemption. Please check back later...', 5, Icons.info, Colors.red);
                                                                                                  } else if (onlyPhone == null && networkController.text.isEmpty) {
                                                                                                    Navigator.of(context).pop();
                                                                                                    showToast('Phone number and network are required...', 3, Icons.info, Colors.red);
                                                                                                  } else if (country1Code != '+234') {
                                                                                                    Navigator.of(context).pop();
                                                                                                    showToast('Non-Nigerians are not allowed', 5, Icons.info, Colors.red);
                                                                                                  }
                                                                                                },
                                                                                                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(37, 211, 102, 1), side: BorderSide.none, shape: const StadiumBorder()
                                                                                                    // fixedSize: Size(250, 50),
                                                                                                    ),
                                                                                                child: const Text(
                                                                                                  "Submit",
                                                                                                  style: TextStyle(color: Colors.white),
                                                                                                ),
                                                                                              ),
                                                                                            ])
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }));
                                                                        } else {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) => AlertDialog(
                                                                                    elevation: 0,
                                                                                    backgroundColor: Colors.white,
                                                                                    title: const Text('Submit Request'),
                                                                                    content: SingleChildScrollView(
                                                                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Center(child: SizedBox(height: 200, width: double.infinity, child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), image: DecorationImage(image: NetworkImage('${userValues[index][0]['imageURL']}')))))),
                                                                                          const SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                          Text('You are about to redeem ${userValues[index][0]['title']} for ${userValues[index][0]['maxPoints']} Max. Kindly fill the required information below to proceed'),
                                                                                          const SizedBox(height: 5),
                                                                                          const Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              Text('* required'),
                                                                                            ],
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          IntlPhoneField(
                                                                                            decoration: const InputDecoration(
                                                                                              fillColor: Color.fromRGBO(37, 211, 102, 0.07),
                                                                                              filled: true,
                                                                                              labelText: 'Phone Number*',
                                                                                              border: OutlineInputBorder(
                                                                                                borderSide: BorderSide.none,
                                                                                              ),
                                                                                            ),
                                                                                            initialCountryCode: 'US',
                                                                                            onChanged: (phone) {
                                                                                              onlyPhone = phone.number;
                                                                                              phoneNumber = phone.completeNumber;
                                                                                              nation = phone.countryISOCode;
                                                                                              countryCode = phone.countryCode;
                                                                                            },
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          TextField(
                                                                                            keyboardType: TextInputType.streetAddress,
                                                                                            controller: addressController,
                                                                                            decoration: InputDecoration(hintText: "Home Address*", border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none), fillColor: const Color.fromRGBO(37, 211, 102, 0.07), filled: true, prefixIcon: const Icon(Icons.house_outlined)),
                                                                                          ),
                                                                                          const SizedBox(height: 18),
                                                                                          TextField(
                                                                                            keyboardType: TextInputType.streetAddress,
                                                                                            controller: address1Controller,
                                                                                            decoration: InputDecoration(hintText: "Line 2 (optional)", border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none), fillColor: const Color.fromRGBO(37, 211, 102, 0.07), filled: true, prefixIcon: const Icon(Icons.house_outlined)),
                                                                                          ),
                                                                                          const SizedBox(height: 18),
                                                                                          TextField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            controller: zipcodeController,
                                                                                            decoration: InputDecoration(hintText: "ZIP code", border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none), fillColor: const Color.fromRGBO(37, 211, 102, 0.07), filled: true, prefixIcon: const Icon(Icons.code)),
                                                                                          ),
                                                                                          const SizedBox(height: 20),
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                                              child: const Text(
                                                                                                "Cancel",
                                                                                                style: TextStyle(color: Colors.red),
                                                                                              ),
                                                                                            ),
                                                                                            ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                if (onlyPhone != null && addressController.text.isNotEmpty) {
                                                                                                  CollectionReference profileRef = FirebaseFirestore.instance.collection('Users');

                                                                                                  final value = await profileRef.where('UserID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
                                                                                                  if (value.docs.isNotEmpty) {
                                                                                                    Random random = Random();
                                                                                                    int randomNumber = random.nextInt(1000000);
                                                                                                    final data = value.docs[0];
                                                                                                    final body = {
                                                                                                      'RefEarnings': data.get('RefEarnings') - userValues[index][0]['redeemPoints']
                                                                                                    };
                                                                                                    await profileRef.doc(data.id).update(body);
                                                                                                    await FirebaseFirestore.instance.collection('RedeemRequests').doc('${FirebaseAuth.instance.currentUser!.email}$randomNumber').set({
                                                                                                      'Name': FirebaseAuth.instance.currentUser?.displayName,
                                                                                                      'Email Address': FirebaseAuth.instance.currentUser?.email,
                                                                                                      'Item': userValues[index][0]['title'],
                                                                                                      'Max Spent': userValues[index][0]['redeemPoints'],
                                                                                                      'Balance': data.get('RefEarnings') - userValues[index][0]['redeemPoints'],
                                                                                                      'Phone Number': phoneNumber,
                                                                                                      'Address': addressController.text,
                                                                                                      'Address Line 2': address1Controller.text,
                                                                                                      'ZIP Code': zipcodeController.text,
                                                                                                      "Country": nation,
                                                                                                      'UserID': FirebaseAuth.instance.currentUser?.uid,
                                                                                                      'Phone': onlyPhone,
                                                                                                      'OrderID': randomNumber,
                                                                                                      'Time': FieldValue.serverTimestamp(),
                                                                                                      'Country Code': countryCode
                                                                                                    });
                                                                                                    await FirebaseFirestore.instance.collection('RedeemHistory').doc('${FirebaseAuth.instance.currentUser!.email}').collection('Redeemed').add({
                                                                                                      'Account Name': FirebaseAuth.instance.currentUser?.displayName,
                                                                                                      'Email Address': FirebaseAuth.instance.currentUser?.email,
                                                                                                      'ItemName': userValues[index][0]['title'],
                                                                                                      'Point': userValues[index][0]['redeemPoints'],
                                                                                                      'Time': DateFormat('K:mm a, EEE - M/d/yy').format(DateTime.now()),
                                                                                                      'Image': userValues[index][0]['imageURL'],
                                                                                                      'OrderID': randomNumber,
                                                                                                      'UserID': FirebaseAuth.instance.currentUser?.uid,
                                                                                                      'Status': 'Pending',
                                                                                                      'created': Timestamp.now(),
                                                                                                      'Reason': 'Please check back later'
                                                                                                    });

                                                                                                    addressController.clear();
                                                                                                    zipcodeController.clear();
                                                                                                    address1Controller.clear();
                                                                                                    Navigator.of(context).pop();
                                                                                                    showToast('Request submitted successfully! We will reach out to you shortly', 5, Icons.check_circle, const Color.fromRGBO(37, 211, 102, 1));
                                                                                                    setState(() {});
                                                                                                  }
                                                                                                } else {
                                                                                                  Navigator.of(context).pop();
                                                                                                  showToast('Phone number and home address are required...', 3, Icons.info, Colors.red);
                                                                                                }
                                                                                              },
                                                                                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(37, 211, 102, 1), side: BorderSide.none, shape: const StadiumBorder()
                                                                                                  // fixedSize: Size(250, 50),
                                                                                                  ),
                                                                                              child: const Text(
                                                                                                "Submit",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ),
                                                                                            ),
                                                                                          ])
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ));
                                                                        }
                                                                      } else {
                                                                        showToast(
                                                                            'You do not have enough Max',
                                                                            5,
                                                                            Icons.info,
                                                                            Colors.red);
                                                                        null;
                                                                      }
                                                                    },
                                                                    child:
                                                                        const Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .card_giftcard,
                                                                            color:
                                                                                Colors.white),
                                                                        SizedBox(
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        Text(
                                                                          'Redeem',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )
                                                                      ],
                                                                    )),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                    const SizedBox(height: 35),
                                    SizedBox(
                                      height: 300,
                                      width: 300,
                                      child: AdWidget(
                                          ad: BannerAd(
                                              size: const AdSize(
                                                  width: 300, height: 300),
                                              adUnitId: getBannerAdUnitId()!,
                                              listener: BannerAdListener(
                                                onAdClicked: (ad) {},
                                              ),
                                              request: const AdRequest(
                                                  nonPersonalizedAds: false))
                                            ..load()),
                                    ),
                                    const SizedBox(height: 35),
                                    FutureBuilder<QuerySnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('Adverts')
                                            .where('DisplayImage',
                                                isNull: false)
                                            .get(),
                                        builder: (context, snapshot) {
                                          final ad = snapshot.data?.docs[0];
                                          final image = ad!.get('DisplayImage');
                                          final link = ad.get('LinkRedirect');

                                          final Uri parseLink = Uri.parse(link);
                                          Future<void> launchUrlExt() async {
                                            if (!await launchUrl(parseLink,
                                                mode: LaunchMode
                                                    .externalApplication)) {
                                              throw Exception(
                                                  'Could not launch $parseLink');
                                            }
                                          }

                                          return GestureDetector(
                                            onTap: launchUrlExt,
                                            child: SizedBox(
                                                height: 300,
                                                width: 300,
                                                child: Image.network(image,
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.medium)),
                                          );
                                        }),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }
}
