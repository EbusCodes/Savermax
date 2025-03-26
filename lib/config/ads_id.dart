String? getBannerAdUnitId({bool isTest = false}) {
  if (isTest) {
      return 'ca-app-pub-3940256099942544/6300978111';
} else if(!isTest) {
 
      return 'ca-app-pub-1479057778220507/7808195454'; 
}

return null;
}


String? getInterstitialAdUnitId({bool isTest = false}) {
  if (isTest) {

      return 'ca-app-pub-3940256099942544/1033173712';
} else if(!isTest) {

      return 'ca-app-pub-1479057778220507/1530507816';
}

return null;
}


String? getRewardBasedVideoAdUnitId({bool isTest = false}) {
  if (isTest) {
      return 'ca-app-pub-3940256099942544/5224354917';

} else if(!isTest) {

      return 'ca-app-pub-1479057778220507/2955324025';
  }

return null;
}
