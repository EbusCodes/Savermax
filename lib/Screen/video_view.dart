// ignore_for_file: non_constant_identifier_names, must_be_immutable
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:savermax/Provider/file_path_provider.dart';

class VideoView extends StatefulWidget {
   String? WAVideoPath;
   VideoView(
      {Key? key, this.WAVideoPath})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  late FToast fToast;

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);

    _videoPlayerController =
        VideoPlayerController.file(File(widget.WAVideoPath!));

    _videoPlayerController.initialize().then(
          (_) => setState(
            () => _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: _videoPlayerController.value.aspectRatio,
              autoPlay: true,
              looping: true,
              allowedScreenSleep: false,
              customControls: const MaterialDesktopControls(),
              showControls: true,
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(errorMessage),
                );
              },
            ),
          ),
        );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
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
            width: 200,
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
    return Consumer<FilePathProvider>(builder: (context, snapshot, childy) {
      return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: [
               FirebaseAuth.instance.currentUser == null
                ? IconButton(
                    highlightColor: Colors.grey,
                    onPressed: () async {
                      ImageGallerySaver.saveFile(widget.WAVideoPath!);
                      showToast(
                        'Video saved successfully',
                        Icons.video_file,
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
                            .addPath(widget.WAVideoPath!, context);
                                              if (snapshot.exists == false) {
                          ImageGallerySaver.saveFile(widget.WAVideoPath!);
                          Navigator.of(context).pop();
                          showToast(
                            'Video saved successfully ',
                            Icons.video_file,
                            const Color.fromRGBO(37, 211, 102, 1),
                          );
                          await FirebaseFirestore.instance
                              .collection('PointsHistory')
                              .doc('${FirebaseAuth.instance.currentUser!.email}')
                              .collection('Points')
                              .add({
                            'FileType': 'Video',
                            'Points': 10,
                            'created': Timestamp.now(),
                            'Time':
                                DateFormat('EEE - dd/MM').format(DateTime.now()),
                            'Hour':  DateFormat('KK:mm a').format(DateTime.now())
                          });
                                              } else if (snapshot.exists == true) {
                          Navigator.of(context).pop();
                          showToast('Video already saved', Icons.video_file, Colors.red);
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(height: 5),
                                                Row(
                                                                          children: [
                                                                           
                                                                            Icon(
                                                                              Icons.video_file,
                                                                              color: Color.fromRGBO(37, 211, 102, 1),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(width: 10),
                                                                                Text(
                                                                                  'Save + Earn 10 Max',
                                                                                  style: TextStyle(color: Color.fromRGBO(37, 211, 102, 1)),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                ),
                                                SizedBox(height: 5)
                                              ],
                                            ),
                                          ),
                          Divider(),

                          TextButton(
                  onPressed: () {
                    ImageGallerySaver.saveFile(widget.WAVideoPath!);
                    Navigator.of(context).pop();
                    showToast(
                      'Video saved successfully',
                      Icons.video_file,
                      const Color.fromRGBO(37, 211, 102, 1),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.video_file,
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text('Save', style: TextStyle(color: Colors.black)),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 5)
                    ],
                  ),
                ),

                        ],
                      )),
                  ],
                  child: Icon(Icons.download, color: Colors.white)),
                   IconButton(
                onPressed: () {
                  FlutterNativeApi.shareImage(widget.WAVideoPath!);
                },
                icon: const Icon(Icons.share),
                color: Colors.white,
              )
            ],
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _videoPlayerController.value.isInitialized
              ?  Center(
                        child: Hero(
                          tag: widget.WAVideoPath!,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: Chewie(controller: _chewieController),
                          ),
                        ),
                      )
              : const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ));
    });
  }
}