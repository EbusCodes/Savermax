import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReferralProvider extends ChangeNotifier {
  String message = "";
  bool _exists = false;
  bool get exists => _exists;

  CollectionReference profileRef =
      FirebaseFirestore.instance.collection('Users');

  FirebaseAuth auth = FirebaseAuth.instance;

  void setRefferal(String refCode) async {
    final value = await profileRef.where('RefCode', isEqualTo: refCode).get();

    try {
      if (value.docs.isEmpty) {
        message = 'Referral code does not exist';
      } else if (value.docs.isNotEmpty &&
          refCode != FirebaseAuth.instance.currentUser?.uid) {
        final data = value.docs[0];
        List referrals = data.get('Referrals');
        message = 'Referral added Successfully';
        if (referrals.contains(auth.currentUser?.displayName) == true) {
          _exists = true;
          notifyListeners();
        } else if (referrals.contains(auth.currentUser?.displayName) == false) {
          _exists = false;
          referrals.add(auth.currentUser?.displayName);
          final body = {
            'Referrals': referrals,
            'RefEarnings': data.get('RefEarnings') + 400
          };
          await profileRef.doc(data.id).update(body);
          await FirebaseFirestore.instance.collection('PointsHistory').doc('${data.get('Email')}').collection('Points').add({
        'FileType': 'Referral',
        'Points': 400,
        'created': Timestamp.now(),
        'Time': DateFormat('EEE - dd/MM').format(DateTime.now()),
        'Hour':  DateFormat('KK:mm a').format(DateTime.now())
        
      });
        }
      }
    } on FirebaseAuthException catch (e) {
      message = e.message.toString();
    }
    notifyListeners();
  }
}
