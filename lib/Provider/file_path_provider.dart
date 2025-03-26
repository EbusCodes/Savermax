// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savermax/Provider/ads_provider.dart';

class FilePathProvider extends ChangeNotifier {
  CollectionReference fileRef =
      FirebaseFirestore.instance.collection('FilePath');
  bool _exists = false;
  bool get exists => _exists;

  final user = FirebaseAuth.instance.currentUser;

  addPath(String filePath, BuildContext context1) async {
    final value = await fileRef.where('UserID', isEqualTo: user?.uid).get();
    final data = value.docs[0];
    List fileNames = data.get('Files');
    final body = {
      'Files': fileNames,
    };
    if (fileNames.contains(filePath)) {
      _exists = true;
    } else {
       _exists = false;
      fileNames.add(filePath);
      fileRef.doc(data.id).update(body).then((value) {
        Provider.of<AdsProvider>(context1, listen: false).showInterstitialAd();
      });
      
    }
    notifyListeners();
  }
}
