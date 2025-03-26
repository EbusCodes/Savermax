import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:savermax/Provider/whatsAppProvider.dart';
import 'package:savermax/Screen/video_view.dart';
import 'package:savermax/Utils/WAThumbnail.dart';
import 'package:savermax/config/ads_id.dart';

class VideoHomePage extends StatefulWidget {
  const VideoHomePage({Key? key}) : super(key: key);

  @override
  State<VideoHomePage> createState() => _ImageHomePageState();
}

class _ImageHomePageState extends State<VideoHomePage>
    with AutomaticKeepAliveClientMixin {
  bool _isFetched = false;
  String? files;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<WhatsAppProvider>(builder: (context, file, child) {
      if (_isFetched == false) {
        file.WhatsAppStatus('.mp4');
        Future.delayed(const Duration(microseconds: 1), () {
          _isFetched = true;
        });
      }
      return file.isWhatsappAvailable == false
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/trans_app_icon.png',
                    color: Colors.grey,
                    width: 100,
                    height: 100,
                  ),
                  const Text('WhatsApp not found or permission denied'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        StoreRedirect.redirect(
                            androidAppId: "com.whatsapp",
                            iOSAppId: "310633997");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(8),
                        backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
                      ),
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Install WhatsApp',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ])),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('OR'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(8),
                        backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
                      ),
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Open Settings',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ])),
                ],
              ),
            )
          : file.getWAVideo.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 40,
                      ),
                      SizedBox(height: 20),
                      Text('You have not viewed video updates today!'),
                    ],
                  ),
                )
              : ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: AdWidget(
                        ad: BannerAd(
                            size: AdSize(height: 60, width: 350),
                            adUnitId: getBannerAdUnitId()!,
                            listener: BannerAdListener(
                              onAdClicked: (ad) {},
                            ),
                            request: const AdRequest(nonPersonalizedAds: true))
                          ..load()),
                  ),
                  subtitle: GridView(
                    padding: const EdgeInsets.fromLTRB(8, 7, 8, 75),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    children: List.generate(file.getWAVideo.length, (index) {
                      final data = file.getWAVideo[index];
                      files = data.path;

                      return FutureBuilder<Uint8List?>(
                          future: getThumbnail(files!),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (_) => VideoView(
                                                    WAVideoPath: data.path,
                                                  )));
                                    },
                                    child: Hero(
                                      tag: data.path,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            // Background Image
                                            Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: MemoryImage(
                                                          snapshot.data!),
                                                      fit: BoxFit.cover)),
                                            ),
                                            // Foreground Image
                                            const Positioned.fill(
                                                child: Icon(
                                              Icons.play_circle,
                                              size: 40,
                                              color: Colors.white,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ))
                                : const Center(
                                    child: CircularProgressIndicator());
                          });
                    }, growable: false),
                  ));
    });
  }
}
