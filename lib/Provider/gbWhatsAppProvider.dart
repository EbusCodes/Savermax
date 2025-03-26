// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:savermax/Constants/constant.dart';

class GBWhatsAppProvider extends ChangeNotifier {
  List<FileSystemEntity> _getGBWAImages = [];
  List<FileSystemEntity> _getGBWAVideo = [];
  List<FileSystemEntity> _getGBWAAudio = [];
  List<FileSystemEntity> _getGBWAText = [];

  bool _isWhatsappAvailable = false;

  List<FileSystemEntity> get getGBWAImages => _getGBWAImages;
  List<FileSystemEntity> get getGBWAVideo => _getGBWAVideo;
  List<FileSystemEntity> get getGBWAAudio => _getGBWAAudio;
  List<FileSystemEntity> get getGBWAText => _getGBWAText;

  bool get isWhatsappAvailable => _isWhatsappAvailable;

  void GBWhatsAppStatus(String ext) async {
    final GBWAdirectory = Directory(AppConstants.GBWHATSAPP_PATH);
    final GBWATextdirectory = Directory(AppConstants.GBWHATSAPP_PATH_TEXT);
    final GBWAdirectory1 = Directory(AppConstants.GBWHATSAPP_PATH1);
    final GBWATextdirectory1 = Directory(AppConstants.GBWHATSAPP_PATH_TEXT1);
    final directory1 = await GBWAdirectory.exists();
    final directory2 = await GBWATextdirectory.exists();
    final directory3 = await GBWAdirectory1.exists();
    final directory4 = await GBWATextdirectory1.exists();
    notifyListeners();

    if (directory1) {
      final items = GBWAdirectory.listSync();
      if (ext == '.jpg') {
        _getGBWAImages =
            items.where((element) => element.path.endsWith('.jpg')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.mp4') {
        _getGBWAVideo =
            items.where((element) => element.path.endsWith('.mp4')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.opus') {
        _getGBWAAudio =
            items.where((element) => element.path.endsWith('.opus')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory2) {
      final items = GBWATextdirectory.listSync();
      if (ext == '.png') {
        _getGBWAText =
            items.where((element) => element.path.endsWith('.png')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory3) {
      final items = GBWAdirectory1.listSync();
      if (ext == '.jpg') {
        _getGBWAImages =
            items.where((element) => element.path.endsWith('.jpg')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.mp4') {
        _getGBWAVideo =
            items.where((element) => element.path.endsWith('.mp4')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.opus') {
        _getGBWAAudio =
            items.where((element) => element.path.endsWith('.opus')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory4) {
      final items = GBWATextdirectory1.listSync();
      if (ext == '.png') {
        _getGBWAText =
            items.where((element) => element.path.endsWith('.png')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory1 == false &&
        directory2 == false &&
        directory3 == false &&
        directory4 == false) {
      log('No WhatsApp Business found!');
      _isWhatsappAvailable = false;
      notifyListeners();
    }
  }
}
