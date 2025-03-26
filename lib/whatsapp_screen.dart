// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:savermax/TabsPages/whatsapp_audio.dart';
import 'package:savermax/TabsPages/whatsapp_image.dart';
import 'package:savermax/TabsPages/whatsapp_text.dart';
import 'package:savermax/TabsPages/whatsapp_video.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final List<Tab> tabs = [
    const Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image),
          SizedBox(
            width: 8,
          ),
          Text('IMAGES'),
        ],
      ),
    ),
    const Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_call_rounded),
          SizedBox(
            width: 8,
          ),
          Text('VIDEOS')
        ],
      ),
    ),
    const Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.text_fields),
          SizedBox(
            width: 8,
          ),
          Text('TEXT')
        ],
      ),
    ),
    const Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.audio_file),
          SizedBox(
            width: 8,
          ),
          Text('AUDIO')
        ],
      ),
    ),
  ];

@override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title:  TabBar(
            dividerColor: Colors.transparent,
            automaticIndicatorColorAdjustment: false,
            unselectedLabelColor: Colors.black,
            labelColor: const Color.fromRGBO(37, 211, 102, 1),
            indicatorColor: const Color.fromRGBO(37, 211, 102, 1),
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: const TabBarView(
          children: [
            ImageHomePage(),
            VideoHomePage(),
            TextHomePage(),
            AudioHomePage(),
          ],
        ),
      ),
    );
  }
}
