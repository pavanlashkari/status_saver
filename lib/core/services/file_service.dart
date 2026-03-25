import 'dart:io';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../models/status_file.dart';

class FileService {
  Future<List<StatusFile>> loadStatuses() async {
    return compute(_scanStatuses, AppConstants.whatsappStatusPaths);
  }

  static List<StatusFile> _scanStatuses(List<String> paths) {
    final List<StatusFile> statuses = [];

    for (final path in paths) {
      final dir = Directory(path);
      if (!dir.existsSync()) continue;

      final files = dir.listSync();
      for (final file in files) {
        if (file is! File) continue;
        final name = file.path.split('/').last;
        if (name.startsWith('.')) continue;

        final ext = name.split('.').last;
        final type = StatusFile.typeFromExtension(ext);
        if (type == null) continue;

        final stat = file.statSync();
        statuses.add(StatusFile(
          path: file.path,
          type: type,
          timestamp: stat.modified,
        ));
      }
    }

    statuses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return statuses;
  }
}
