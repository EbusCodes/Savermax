import 'dart:developer';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final AsyncMemoizer memoizer = AsyncMemoizer();

Future<Uint8List?> getThumbnail(String path) async {
  try {
    final thumb = await VideoThumbnail.thumbnailData(
            video: path, imageFormat: ImageFormat.JPEG, quality: 25)
        .timeout(const Duration(seconds: 120000));
    return thumb;
  } catch (error) {
    log(error.toString());
  }
  return null;
}
