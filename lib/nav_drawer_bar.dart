import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:savermax/Screen/about_app_page.dart';
import 'package:savermax/Screen/login_page.dart';
import 'package:savermax/Screen/norewards_page.dart';
import 'package:savermax/Screen/privacy_policy_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const UserAccountsDrawerHeader(
          accountEmail: null,
          accountName: Text(""),
          currentAccountPicture: Text(''),
          decoration: BoxDecoration(
              color: Color.fromRGBO(37, 211, 102, 1),
              image: DecorationImage(image: AssetImage('images/trans_app_icon.png'))),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (_) => const WarningPage()));
          },
          leading: const Icon(Icons.money),
          title: const Text('Rewards Center'),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (_) => const AboutAppPage()));
          },
          leading: const Icon(Icons.app_shortcut),
          title: const Text('About App'),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (_) => const WarningPage()));
          },
          leading: const Icon(Icons.contact_mail),
          title: const Text('Contact Us'),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (_) => const PrivacyPolicyPage()));
          },
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
        ),
        ListTile(
          onTap: () async {
            String shareLink =
                'Download SaverMax today, save your WhatsApp status updates and get rewarded. You also stand a chance to win amazing prizes. Don\'t miss out, download now! https://play.google.com/store/apps/details?id=com.savermax';
            Share.share(shareLink);
            await FirebaseAnalytics.instance.logEvent(name: 'share');
          },
          leading: const Icon(Icons.share),
          title: const Text('Share App'),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (_) => const LoginPage()));
          },
          leading: const Icon(Icons.login),
          title: const Text('Sign in'),
        )
      ],
    ));
  }
}
