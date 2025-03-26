// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savermax/Provider/file_path_provider.dart';
import 'package:savermax/config/ads_id.dart';

class ImageView extends StatefulWidget {
  String? WAImagePath;
  final int? index;
  final int? length;
  final List<FileSystemEntity>? file;
  ImageView({Key? key, this.WAImagePath, this.index, this.length, this.file})
      : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late PageController _controller;
  late FToast fToast;
  late int item;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);
  }

  showToast(String message, IconData icon, Color color) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
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
            width: 190,
            child: Text(
              message,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller = PageController(initialPage: widget.index!);

    void handleDrag(details) {
      Navigator.pop(context);
    }

    return Consumer<FilePathProvider>(builder: (context, snapshot, child) {
      return Scaffold(
          bottomNavigationBar: SizedBox(
            height: 80,
            child: AdWidget(
                ad: BannerAd(
                    size: AdSize(height: 60, width: 350),
                    adUnitId: getBannerAdUnitId()!,
                    listener: BannerAdListener(
                      onAdClicked: (ad) {},
                    ),
                    request: const AdRequest(nonPersonalizedAds: false))
                  ..load()),
          ),
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            actions: [
              FirebaseAuth.instance.currentUser == null
                  ? IconButton(
                      highlightColor: Colors.grey,
                      onPressed: () async {
                        ImageGallerySaver.saveFile(widget.WAImagePath!);
                        showToast(
                          'Image saved successfully',
                          Icons.image,
                          const Color.fromRGBO(37, 211, 102, 1),
                        );
                      },
                      icon: Icon(Icons.download),
                      color: Colors.white,
                    )
                  : PopupMenuButton(
                      position: PopupMenuPosition.under,
                      padding: EdgeInsets.all(1),
                      elevation: 0,
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                child: Column(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<FilePathProvider>(context,
                                            listen: false)
                                        .addPath(widget.WAImagePath!, context);
                                    if (snapshot.exists == false) {
                                      ImageGallerySaver.saveFile(
                                          widget.WAImagePath!);
                                      Navigator.of(context).pop();
                                      showToast(
                                        'Image saved successfully ',
                                        Icons.image,
                                        const Color.fromRGBO(37, 211, 102, 1),
                                      );
                                      await FirebaseFirestore.instance
                                          .collection('PointsHistory')
                                          .doc(
                                              '${FirebaseAuth.instance.currentUser!.email}')
                                          .collection('Points')
                                          .add({
                                        'FileType': 'Image',
                                        'Points': 10,
                                        'created': Timestamp.now(),
                                        'Time': DateFormat('EEE - dd/MM')
                                            .format(DateTime.now()),
                                        'Hour': DateFormat('KK:mm a')
                                            .format(DateTime.now())
                                      });
                                    } else if (snapshot.exists == true) {
                                      Navigator.of(context).pop();
                                      showToast('Image already saved',
                                          Icons.image, Colors.red);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color:
                                                Color.fromRGBO(37, 211, 102, 1),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Text(
                                                'Save + Earn 10 Max',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        37, 211, 102, 1)),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                Divider(),
                                TextButton(
                                  onPressed: () {
                                    ImageGallerySaver.saveFile(
                                        widget.WAImagePath!);
                                    Navigator.of(context).pop();
                                    showToast(
                                      'Image saved successfully',
                                      Icons.image,
                                      const Color.fromRGBO(37, 211, 102, 1),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: Colors.black,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Text('Save',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                )
                              ],
                            )),
                          ],
                      child: Icon(Icons.download, color: Colors.white)),
              IconButton(
                onPressed: () {
                  FlutterNativeApi.printImage(
                      widget.WAImagePath, widget.WAImagePath!.split('/').last);
                },
                icon: const Icon(Icons.print),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  FlutterNativeApi.shareImage(widget.WAImagePath!);
                },
                icon: const Icon(Icons.share),
                color: Colors.white,
              )
            ],
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: PageView.builder(
              controller: _controller,
              itemBuilder: (context, position) {
                item = position;
                return Center(
                  child: Hero(
                    tag: widget.file![position].path,
                    child: GestureDetector(
                        onVerticalDragEnd: handleDrag,
                        child: InteractiveViewer(
                          panEnabled: false,
                          scaleEnabled: false,
                          boundaryMargin: const EdgeInsets.all(20.0),
                          minScale: 0.5,
                          maxScale: 5.0,
                          child: Image.file(File(widget.file![position].path)),
                        )),
                  ),
                );
              },
              onPageChanged: (value) {
                setState(() {
                  widget.WAImagePath = widget.file![item].path;
                });
              },
              itemCount: widget.length,
            ),
          ));
    });
  }
}
