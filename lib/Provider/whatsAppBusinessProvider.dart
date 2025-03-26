// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:savermax/Constants/constant.dart';

class WhatsAppBusinessProvider extends ChangeNotifier {
  List<FileSystemEntity> _getWABImages = [];
  List<FileSystemEntity> _getWABVideo = [];
  List<FileSystemEntity> _getWABAudio = [];
  List<FileSystemEntity> _getWABText = [];

  bool _isWhatsappAvailable = false;

  List<FileSystemEntity> get getWABImages => _getWABImages;
  List<FileSystemEntity> get getWABVideo => _getWABVideo;
  List<FileSystemEntity> get getWABAudio => _getWABAudio;
  List<FileSystemEntity> get getWABText => _getWABText;

  bool get isWhatsappAvailable => _isWhatsappAvailable;

  void WhatsAppBusinessStatus(String ext) async {
    final WABdirectory = Directory(AppConstants.WHATSAPP_BUSINESS_PATH);
    final WABTextdirectory = Directory(AppConstants.WHATSAPP_BUSINESS_TEXT);
    final WABdirectory1 = Directory(AppConstants.WHATSAPP_BUSINESS_PATH1);
    final WABTextdirectory1 = Directory(AppConstants.WHATSAPP_BUSINESS_TEXT1);
    final directory1 = await WABdirectory.exists();
    final directory2 = await WABTextdirectory.exists();
    final directory3 = await WABdirectory1.exists();
    final directory4 = await WABTextdirectory1.exists();
    notifyListeners();

    if (directory1) {
      final items = WABdirectory.listSync();
      if (ext == '.jpg') {
        _getWABImages =
            items.where((element) => element.path.endsWith('.jpg')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.mp4') {
        _getWABVideo =
            items.where((element) => element.path.endsWith('.mp4')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.opus') {
        _getWABAudio =
            items.where((element) => element.path.endsWith('.opus')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory2) {
      final items = WABTextdirectory.listSync();
      if (ext == '.png') {
        _getWABText =
            items.where((element) => element.path.endsWith('.png')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory3) {
      final items = WABdirectory1.listSync();
      if (ext == '.jpg') {
        _getWABImages =
            items.where((element) => element.path.endsWith('.jpg')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.mp4') {
        _getWABVideo =
            items.where((element) => element.path.endsWith('.mp4')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (ext == '.opus') {
        _getWABAudio =
            items.where((element) => element.path.endsWith('.opus')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (directory4) {
      final items = WABTextdirectory1.listSync();
      if (ext == '.png') {
        _getWABText =
            items.where((element) => element.path.endsWith('.png')).map((e) => (e as File))
            .toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      }
      _isWhatsappAvailable = true;

      log(items.toString());
    }

    if (await WABdirectory.exists() == false &&
        await WABTextdirectory.exists() == false &&
        await WABdirectory1.exists() == false &&
        await WABTextdirectory1.exists() == false) {
      log('No WhatsApp Business found!');
      _isWhatsappAvailable = false;
      notifyListeners();
    }
  }
}
