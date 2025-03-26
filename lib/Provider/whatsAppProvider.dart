// ignore_for_file: non_constant_identifier_names, unused_element

import 'dart:developer';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:savermax/Constants/constant.dart';

class WhatsAppProvider extends ChangeNotifier {
  List<FileSystemEntity> _getWAImages = [];
  List<FileSystemEntity> _getWAVideo = [];
  List<FileSystemEntity> _getWAAudio = [];
  List<FileSystemEntity> _getWAText = [];

  bool _isWhatsappAvailable = true;

  List<FileSystemEntity> get getWAImages => _getWAImages;
  List<FileSystemEntity> get getWAVideo => _getWAVideo;
  List<FileSystemEntity> get getWAAudio => _getWAAudio;
  List<FileSystemEntity> get getWAText => _getWAText;

  bool get isWhatsappAvailable => _isWhatsappAvailable;

  void WhatsAppStatus(String ext) async {
    final status = await Permission.storage.request();
    await Permission.photos.request();
    await Permission.videos.request();
    await Permission.audio.request();
    await Permission.manageExternalStorage.request();

    final WAdirectory = Directory(AppConstants.WHATSAPP_PATH);
    final WATextdirectory = Directory(AppConstants.WHATSAPP_PATH_TEXT);
    final WAdirectory1 = Directory(AppConstants.WHATSAPP_PATH1);
    final WATextdirectory1 = Directory(AppConstants.WHATSAPP_PATH_TEXT1);
    final directory1 = await WAdirectory.exists();
    final directory2 = await WATextdirectory.exists();
    final directory3 = await WAdirectory1.exists();
    final directory4 = await WATextdirectory1.exists();

    if (status.isGranted) {
      notifyListeners();
    }

    if (directory1) {
      final items = WAdirectory.listSync();
      if (ext == '.jpg') {
        _getWAImages = items
            .where((element) => element.path.endsWith('.jpg'))
            .map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.mp4') {
        _getWAVideo =
            items.where((element) => element.path.endsWith('.mp4')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.opus') {
        _getWAAudio =
            items.where((element) => element.path.endsWith('.opus')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory2) {
      final items = WATextdirectory.listSync();
      if (ext == '.png') {
        _getWAText =
            items.where((element) => element.path.endsWith('.png')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;
      log(items.toString());
    }

    if (directory3) {
      final items = WAdirectory1.listSync();
      if (ext == '.jpg') {
        _getWAImages =
            items.where((element) => element.path.endsWith('.jpg')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.mp4') {
        _getWAVideo =
            items.where((element) => element.path.endsWith('.mp4')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.opus') {
        _getWAAudio =
            items.where((element) => element.path.endsWith('.opus')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory4) {
      final items = WATextdirectory1.listSync();
      if (ext == '.png') {
        _getWAText =
            items.where((element) => element.path.endsWith('.png')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory4 == false &&
        directory1 == false &&
        directory3 == false &&
        directory2 == false) {
      log('No WhatsApp Business found!');
      _isWhatsappAvailable = false;
      notifyListeners();
    }

    if (!status.isGranted) {
      Permission.storage.request();
      log("Permission denied");
      return;
    }

    if (status.isPermanentlyDenied ||
        await Permission.manageExternalStorage.isPermanentlyDenied ||
        await Permission.audio.isPermanentlyDenied ||
        await Permission.videos.isPermanentlyDenied ||
        await Permission.photos.isPermanentlyDenied) {
      _isWhatsappAvailable = false;
      openAppSettings();
    }
  }
}
