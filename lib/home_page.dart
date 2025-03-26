import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:savermax/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:savermax/Provider/ads_provider.dart';
import 'package:savermax/Screen/login_page.dart';
import 'package:savermax/gbwhatsapp_screen.dart';
import 'package:savermax/whatsapp_screen.dart';
import 'package:savermax/nav_drawer_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savermax/nav_drawer_user.dart';
import 'package:savermax/whatsappbusiness_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final keyIsFirstLoaded = 'is_first_loaded';
  Color color = Colors.black;
  Color color1 = Colors.black;
  bool isVisible = true;

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 1,
    minLaunches: 4,
    remindDays: 3,
    remindLaunches: 5,
    // googlePlayIdentifier: 'fr.skyost.example',
    // appStoreIdentifier: '1491556149',
  );
  final navScreens = [
    const HomeScreen(),
    const WABHomeScreen(),
    const GBHomeScreen()
  ];

  late FToast fToast;

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
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Future.delayed(Duration.zero, () => showDialogIfFirstLoaded(context));
      Provider.of<AdsProvider>(context, listen: false).loadInterstitialAd();
      Provider.of<AdsProvider>(context, listen: false).loadRewardedAd();
    }

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showStarRateDialog(
          context,

          title: 'Enjoying SaverMax?', // The dialog title.
          message:
              'We would love to hear your feedback! This will help us serve you better, kindly rate us 5 stars!', // The dialog message.
          // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
          actionsBuilder: (context, stars) {
            // Triggered when the user updates the star rating.
            return [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('LATER',
                        style:
                            TextStyle(color: Color.fromRGBO(37, 211, 102, 1))),
                    onPressed: () async {
                      rateMyApp
                          .callEvent(RateMyAppEventType.laterButtonPressed);
                      Navigator.pop<RateMyAppDialogButton>(
                          context, RateMyAppDialogButton.rate);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'RATE NOW',
                      style: TextStyle(color: Color.fromRGBO(37, 211, 102, 1)),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await Future.delayed(const Duration(seconds: 1));

                      StoreRedirect.redirect(
                          androidAppId: "com.savermax", iOSAppId: "585027354");

                      await rateMyApp
                          .callEvent(RateMyAppEventType.rateButtonPressed);
                      // ignore: use_build_context_synchronously
                    },
                  ),
                ],
              ) // Return a list of actions (that will be shown at the bottom of the dialog).
            ];
          },
          ignoreNativeDialog: Platform
              .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: const DialogStyle(
            // Custom dialog styles.
            titleAlign: TextAlign.start,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20),
          ),
          starRatingOptions:
              const StarRatingOptions(), // Custom star bar rating options.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int selectedIndex = 0;

  void changeSelectedIndex(int pageNumber) {
    selectedIndex = pageNumber;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Semantics(
      label: 'Main homepage',
      child: Scaffold(
        floatingActionButton: user == null
            ? Visibility(
                visible: isVisible,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isVisible = false;
                    });
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      headerAnimationLoop: true,
                      title: 'Want to earn?',
                      desc:
                          'Sign in to your account today and stand a chance to win amazing prizes',
                      btnOkOnPress: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const LoginPage()));
                      },
                      dismissOnBackKeyPress: true,
                      dismissOnTouchOutside: true,
                      showCloseIcon: false,
                      onDismissCallback: (type) {
                        setState(() {
                          isVisible = true;
                        });
                      },
                      btnOk: Center(
                        child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const LoginPage())),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color.fromRGBO(37, 211, 102, 1)
                              // fixedSize: Size(250, 50),
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 10),
                              const Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 10)
                            ],
                          ),
                        ),
                      ),
                    ).show();
                  },
                  child: Semantics(
                    label: 'Gift floating button',
                    child: SizedBox(
                        height: 90,
                        width: 80,
                        child: Lottie.asset('images/gift_box.json',
                            width: 80, height: 90)),
                  ),
                ),
              )
            : null,
        drawer: user != null ? const NavBarUser() : const NavBar(),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Semantics(
            label: 'App title, SaverMax',
            child: const Text("SaverMax")),
          backgroundColor: Color.fromRGBO(37, 211, 102, 1),
          centerTitle: false,
          actions: [
            Semantics(
              label: 'Restart app button',
              child: IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
              CupertinoPageRoute(builder: (_) => const MyApp()), (route) => false);
                  },
                  icon: Icon(Icons.refresh_outlined)),
            )
          ],
        ),
        body: Center(
          child: navScreens.elementAt(selectedIndex),
        ),
        bottomNavigationBar: GNav(
          selectedIndex: selectedIndex,
          onTabChange: (value) {
            changeSelectedIndex(value);
            if (selectedIndex == 1) {
              setState(() {
                color = const Color.fromRGBO(37, 211, 102, 1);
              });
            } else {
              setState(() {
                color = Colors.black;
              });
            }
      
            if (selectedIndex == 2) {
              setState(() {
                color1 = const Color.fromRGBO(37, 211, 102, 1);
              });
            } else {
              setState(() {
                color1 = Colors.black;
              });
            }
          },
          backgroundColor: Colors.white,
          color: Colors.black,
          gap: 10,
          textSize: 9,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          hoverColor: const Color.fromRGBO(0, 0, 0, 0.25),
          tabMargin: const EdgeInsets.only(left: 2, right: 2),
          activeColor: const Color.fromRGBO(37, 211, 102, 1),
          tabs: [
            const GButton(
              icon: FontAwesomeIcons.whatsapp,
              text: 'WhatsApp',
            ),
            GButton(
              leading: Image.asset(
                'images/wb_icon.ico',
                height: 28,
                filterQuality: FilterQuality.medium,
                width: 28,
                color: color,
              ),
              icon: FontAwesomeIcons.b,
              text: 'WA Bussiness',
            ),
            GButton(
              leading: Image.asset(
                'images/gb_whatsapp.ico',
                height: 28,
                width: 28,
                filterQuality: FilterQuality.medium,
                color: color1,
              ),
              icon: FontAwesomeIcons.g,
              text: 'GB WhatsApp',
            ),
          ],
        ),
      ),
    );
  }

  showDialogIfFirstLoaded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          prefs.setBool(keyIsFirstLoaded, false);
                        },
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(color: Colors.green),
                        ))
                  ],
                  title: Row(
                    children: [
                      const Text('Congratulations'),
                      const SizedBox(
                        width: 3,
                      ),
                      Lottie.asset('images/congratulations.json',
                          height: 40, width: 70)
                    ],
                  ),
                  content: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image(
                              image: NetworkImage(FirebaseAuth
                                      .instance.currentUser?.photoURL ??
                                  'https://cobaltsettlements.com/wp-content/uploads/2019/03/blank-profile.jpg'),
                              height: 90.0,
                              fit: BoxFit.fill,
                              width: 90.0,
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ?? ' ',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                            'You can now earn Max points when you save images, videos or audio files and redeem exciting prizes! Start saving now',
                            textAlign: TextAlign.start),
                      ],
                    ),
                  )));
    }
  }
}
