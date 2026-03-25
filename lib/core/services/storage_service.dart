import 'dart:io';
import '../constants/app_constants.dart';
import '../models/status_file.dart';

class StorageService {
  Future<bool> saveStatus(StatusFile status) async {
    try {
      final saveDir = Directory(AppConstants.savePath);
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }

      final destPath = '${AppConstants.savePath}/${status.name}';
      await status.file.copy(destPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<List<StatusFile>> loadSavedStatuses() async {
    final dir = Directory(AppConstants.savePath);
    if (!await dir.exists()) return [];

    final List<StatusFile> statuses = [];
    final files = await dir.list().toList();

    for (final file in files) {
      if (file is! File) continue;
      final name = file.path.split('/').last;
      final ext = name.split('.').last;
      final type = StatusFile.typeFromExtension(ext);
      if (type == null) continue;

      final stat = await file.stat();
      statuses.add(StatusFile(
        path: file.path,
        type: type,
        timestamp: stat.modified,
      ));
    }

    statuses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return statuses;
  }
}
