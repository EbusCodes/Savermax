// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savermax/Provider/file_path_provider.dart';
import 'package:savermax/config/ads_id.dart';

class AudioView extends StatefulWidget {
  final String? WAAudioPath;
  const AudioView({Key? key, this.WAAudioPath}) : super(key: key);

  @override
  State<AudioView> createState() => _VideoViewState();
}

class _VideoViewState extends State<AudioView> {
  ///list of buttons

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    setAudio();
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    final file = File(widget.WAAudioPath!);
    audioPlayer.setSourceUrl(file.path);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    audioPlayer.pause();
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
    return Consumer<FilePathProvider>(builder: (context, snapshot, child) {
      final file = File(widget.WAAudioPath!);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final filePath = '/storage/emulated/0/Music/$timestamp.opus';
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
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            actions: [
              FirebaseAuth.instance.currentUser == null
                  ? IconButton(
                      highlightColor: Colors.grey,
                      onPressed: () async {
                        await file.copy(filePath);
                        showToast(
                          'Audio saved successfully',
                          Icons.audio_file,
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
                                        .addPath(widget.WAAudioPath!, context);
                                    if (snapshot.exists == false) {
                                      await file.copy(filePath);
                                      Navigator.of(context).pop();
                                      showToast(
                                        'Audio saved successfully ',
                                        Icons.audio_file,
                                        const Color.fromRGBO(37, 211, 102, 1),
                                      );
                                      await FirebaseFirestore.instance
                                          .collection('PointsHistory')
                                          .doc(
                                              '${FirebaseAuth.instance.currentUser!.email}')
                                          .collection('Points')
                                          .add({
                                        'FileType': 'Audio',
                                        'Points': 10,
                                        'created': Timestamp.now(),
                                        'Time': DateFormat('EEE - dd/MM')
                                            .format(DateTime.now()),
                                        'Hour': DateFormat('KK:mm a')
                                            .format(DateTime.now())
                                      });
                                    } else if (snapshot.exists == true) {
                                      Navigator.of(context).pop();
                                      showToast('Audio already saved',
                                          Icons.audio_file, Colors.red);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.audio_file,
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
                                  onPressed: () async {
                                    await file.copy(filePath);
                                    Navigator.of(context).pop();
                                    showToast(
                                      'Audio saved successfully',
                                      Icons.audio_file,
                                      const Color.fromRGBO(37, 211, 102, 1),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.audio_file,
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
                                ),
                              ],
                            )),
                          ],
                      child: Icon(Icons.download, color: Colors.white)),
              IconButton(
                onPressed: () {
                  FlutterNativeApi.shareVideo(widget.WAAudioPath!);
                },
                icon: const Icon(Icons.share),
                color: Colors.white,
              )
            ],
            backgroundColor: Colors.black,
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/audio.png',
                    width: double.infinity,
                    height: 350,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                    thumbColor: const Color.fromRGBO(37, 211, 102, 1),
                    activeColor: const Color.fromRGBO(37, 211, 102, 1),
                    value: position.inSeconds.roundToDouble(),
                    max: duration.inSeconds.roundToDouble(),
                    min: 0,
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);

                      await audioPlayer.resume();
                    }),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(position.toString(),
                          style: const TextStyle(color: Colors.white)),
                      Text((duration - position).toString(),
                          style: const TextStyle(color: Colors.white))
                    ]),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        await audioPlayer.resume();
                      }
                    },
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 50,
                    color: const Color.fromRGBO(37, 211, 102, 1),
                  ),
                )
              ],
            ),
          ));
    });
  }
}
