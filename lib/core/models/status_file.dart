import 'dart:io';

enum StatusType { image, video }

class StatusFile {
  final String path;
  final StatusType type;
  final DateTime timestamp;
  String? thumbnailPath;

  StatusFile({
    required this.path,
    required this.type,
    required this.timestamp,
    this.thumbnailPath,
  });

  String get name => path.split('/').last;

  String get extension => name.split('.').last.toLowerCase();

  File get file => File(path);

  bool get isVideo => type == StatusType.video;

  bool get isImage => type == StatusType.image;

  static StatusType? typeFromExtension(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return StatusType.image;
      case 'mp4':
      case 'mkv':
      case 'avi':
      case '3gp':
        return StatusType.video;
      default:
        return null;
    }
  }
}
