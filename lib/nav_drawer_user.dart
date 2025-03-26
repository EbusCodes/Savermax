import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:savermax/Screen/about_app_page.dart';
import 'package:savermax/Screen/contact_us_page.dart';
import 'package:savermax/Screen/privacy_policy_page.dart';
import 'package:savermax/Screen/profile_page.dart';
import 'package:savermax/Screen/rewards_page.dart';


class NavBarUser extends StatelessWidget {
  const NavBarUser({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
            accountEmail: null,
            accountName: Text(user?.displayName ?? ""),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.push(context,
          CupertinoPageRoute(builder: (_) => const ProfilePage()));
              },
              child: CircleAvatar(
                  child: ClipOval(
                      child: Image(image: NetworkImage(user?.photoURL ?? "https://cobaltsettlements.com/wp-content/uploads/2019/03/blank-profile.jpg"), fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,))),
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(37, 211, 102, 1),
            )),
         ListTile(
      onTap: () {
             Navigator.push(
                context, CupertinoPageRoute(builder: (_) =>  const ReedemPoint()));
          },
          leading: const Icon(Icons.money),
          title: const Text('Rewards Center'),
        ),
         ListTile(
          onTap: () {
             Navigator.push(
                context, CupertinoPageRoute(builder: (_) =>  const AboutAppPage()));
          },
          leading: const Icon(Icons.app_shortcut),
          title: const Text('About App'),
        ),
         ListTile(
          onTap: () {
             Navigator.push(
                context, CupertinoPageRoute(builder: (_) =>  ContactUsPage()));
          },
          leading: const Icon(Icons.contact_mail),
          title: const Text('Contact Us'),
        ),
         ListTile(
          onTap: () {
             Navigator.push(
                context, CupertinoPageRoute(builder: (_) =>  const PrivacyPolicyPage()));
          },
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
        ),
        ListTile(
          onTap: ()async  {
            String shareLink =
                'Download SaverMax today, save your WhatsApp status updates and get rewarded. You also stand a chance to win amazing prizes. Don\'t miss out, download now! https://play.google.com/store/apps/details?id=com.savermax';
            Share.share(shareLink);
                await FirebaseAnalytics.instance.logEvent(name: 'login');
          },
          leading: const Icon(Icons.share),
          title: const Text('Share App'),
        ),
      ],
    ));
  }
}
