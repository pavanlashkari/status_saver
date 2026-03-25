import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailService {
  String? _cacheDir;

  Future<String> get _cachePath async {
    if (_cacheDir != null) return _cacheDir!;
    final dir = await getTemporaryDirectory();
    _cacheDir = '${dir.path}/thumbnails';
    await Directory(_cacheDir!).create(recursive: true);
    return _cacheDir!;
  }

  Future<String?> generateThumbnail(String videoPath) async {
    final fileName = videoPath.split('/').last.replaceAll(RegExp(r'\.\w+$'), '.jpg');
    final cachePath = await _cachePath;
    final thumbPath = '$cachePath/$fileName';

    // Return cached thumbnail if exists
    if (await File(thumbPath).exists()) return thumbPath;

    try {
      final result = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: cachePath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 75,
      );
      return result;
    } catch (_) {
      return null;
    }
  }
}
