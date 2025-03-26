import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:savermax/Provider/gbWhatsAppProvider.dart';
import 'package:savermax/Screen/image_view.dart';
import 'package:savermax/config/ads_id.dart';

class GBTextHomePage extends StatefulWidget {
  const GBTextHomePage({Key? key}) : super(key: key);

  @override
  State<GBTextHomePage> createState() => _ImageHomePageState();
}

class _ImageHomePageState extends State<GBTextHomePage> {
  bool _isFetched = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GBWhatsAppProvider>(builder: (context, file, child) {
      if (_isFetched == false) {
        file.GBWhatsAppStatus('.png');
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
                  const Text('GB WhatsApp not found or permission denied'),
                  const SizedBox(height: 20),
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
          : file.getGBWAText.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 40,
                        color: Colors.red,
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                          width: 280,
                          child: Text(
                            'To convert your text status updates to images, open your status page and click the menu button then click on share to generate the image then come back here to save it to your device. Please note that WhatsApp does not allow the saving of contact\'s text status updates yet',
                            textAlign: TextAlign.center,
                          )),
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
                    children: List.generate(
                      file.getGBWAText.length,
                      (index) {
                        final data = file.getGBWAText;
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => ImageView(
                                            WAImagePath: data[index].path,
                                            index: index,
                                            length: data.length,
                                            file: data,
                                          )));
                            },
                            child: Hero(
                              tag: data[index].path,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover,
                                        image:
                                            FileImage(File(data[index].path))),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ));
                      },
                    ),
                  ));
    });
  }
}
