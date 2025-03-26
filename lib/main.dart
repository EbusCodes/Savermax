
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:savermax/Provider/file_path_provider.dart';
import 'package:savermax/Provider/gbWhatsAppProvider.dart';
import 'package:savermax/Provider/whatsAppBusinessProvider.dart';
import 'package:savermax/Provider/whatsAppProvider.dart';
import 'package:savermax/Provider/ads_provider.dart';
import 'package:savermax/Provider/ref_provider.dart';
import 'package:savermax/Screen/splash_screen.dart';
import 'package:savermax/api/firebase_api.dart';
import 'package:savermax/config/user_auth.dart';
import 'package:savermax/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.logAppOpen();
  await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WhatsAppProvider()),
          ChangeNotifierProvider(create: (_) => WhatsAppBusinessProvider()),
          ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
          ChangeNotifierProvider(create: (_) => ReferralProvider()),
          ChangeNotifierProvider(create: (_) => AdsProvider()),
          ChangeNotifierProvider(create: (_) => GBWhatsAppProvider()),
          ChangeNotifierProvider(create: (_) => FilePathProvider())
        ],
        child:  MaterialApp(
          builder: FToastBuilder(),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          
        ));
  }
}
