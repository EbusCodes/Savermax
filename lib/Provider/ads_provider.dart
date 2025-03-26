import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:savermax/config/ads_id.dart';

class AdsProvider extends ChangeNotifier {
  bool _rewardedDismissed = false;
  bool _rewardedFailed = false;

  bool get rewardedDismissed => _rewardedDismissed;
  bool get rewardedFailed => _rewardedFailed;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  CollectionReference profileRef =
      FirebaseFirestore.instance.collection('Users');
  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getInterstitialAdUnitId()!,
        request: const AdRequest(nonPersonalizedAds: true),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < 3) {
              loadInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() async {
    if (_interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }
    await Future.delayed(const Duration(seconds: 1), () async {
      final user = FirebaseAuth.instance.currentUser;
      final value =
          await profileRef.where('UserID', isEqualTo: user?.uid).get();
      if (value.docs.isNotEmpty && user != null) {
        final data = value.docs[0];
        final body = {'RefEarnings': data.get('RefEarnings') + 10};
        await profileRef.doc(data.id).update(body);
        notifyListeners();
      }
    });
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        log('ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
    notifyListeners();
  }

  void loadRewardedAd() async {
    RewardedAd.load(
        adUnitId: getRewardBasedVideoAdUnitId()!,
        request: const AdRequest(nonPersonalizedAds: true),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < 3) {
              loadInterstitialAd();
            }
          },
        ));
  }

  Future showRewardedAd() async {
    if (_rewardedAd == null) {
      log('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        log('ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) async {
        log('$ad onAdDismissedFullScreenContent.');
        _rewardedDismissed = true;
        ad.dispose();
        loadRewardedAd();
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) async {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        _rewardedFailed = true;
        ad.dispose();
        loadRewardedAd();
        notifyListeners();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      final value = await profileRef
          .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (value.docs.isNotEmpty) {
        final data = value.docs[0];

        final body = {'RefEarnings': data.get('RefEarnings') + 15};
        await profileRef.doc(data.id).update(body);
      }
      FirebaseAnalytics.instance.logEvent(name: 'ad_impression');
      await FirebaseFirestore.instance
          .collection('PointsHistory')
          .doc('${FirebaseAuth.instance.currentUser!.email}')
          .collection('Points')
          .add({
        'FileType': 'Ads',
        'Points': 15,
        'created': Timestamp.now(),
        'Time': DateFormat('EEE - dd/MM').format(DateTime.now()),
        'Hour':  DateFormat('KK:mm a').format(DateTime.now())
      });
    });

    _rewardedAd = null;
    notifyListeners();
  }
}
