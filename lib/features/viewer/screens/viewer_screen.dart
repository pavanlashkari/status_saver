import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import '../../../core/models/status_file.dart';
import '../../../core/services/storage_service.dart';
import '../widgets/image_viewer.dart';
import '../widgets/video_viewer.dart';

class ViewerScreen extends StatefulWidget {
  final List<StatusFile> statuses;
  final int initialIndex;

  const ViewerScreen({
    super.key,
    required this.statuses,
    required this.initialIndex,
  });

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  StatusFile get _currentStatus => widget.statuses[_currentIndex];

  Future<void> _saveStatus() async {
    final saved = await _storageService.saveStatus(_currentStatus);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(saved ? 'Saved successfully!' : 'Failed to save'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _shareStatus() async {
    await Share.shareXFiles([XFile(_currentStatus.path)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
            Navigator.of(context).pop();
          }
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.statuses.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            final status = widget.statuses[index];
            return Hero(
              tag: status.path,
              child: status.isImage
                  ? ImageViewer(status: status)
                  : VideoViewer(status: status),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 8,
          top: 8,
          left: 16,
          right: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.download_rounded, color: Colors.white, size: 28),
              onPressed: _saveStatus,
            ),
            IconButton(
              icon: const Icon(Icons.share_rounded, color: Colors.white, size: 28),
              onPressed: _shareStatus,
            ),
          ],
        ),
      ),
    );
  }
}
