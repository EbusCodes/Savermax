// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:savermax/TabsPages/whatsappbusiness_audio.dart';
import 'package:savermax/TabsPages/whatsappbusiness_image.dart';
import 'package:savermax/TabsPages/whatsappbusiness_text.dart';
import 'package:savermax/TabsPages/whatsappbusiness_video.dart';

class WABHomeScreen extends StatefulWidget {
 const WABHomeScreen({super.key});

  @override
  State<WABHomeScreen> createState() => _WABHomeScreenState();
}

class _WABHomeScreenState extends State<WABHomeScreen> with AutomaticKeepAliveClientMixin {
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
        appBar:  AppBar(
          backgroundColor: Colors.white,
          title: TabBar(
            dividerColor: Colors.transparent,
            unselectedLabelColor: Colors.black,
              labelColor: const Color.fromRGBO(37, 211, 102, 1),
              indicatorColor: const Color.fromRGBO(37, 211, 102, 1),
              isScrollable: true,
              tabs: tabs,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        
        body: 
        const TabBarView(
          children: [
            BusinessImageHomePage(),
            BusinessVideoHomePage(),
            BusinessTextHomePage(),
            BusinessAudioHomePage(),
          ],
        ),
),
    );
  }
}