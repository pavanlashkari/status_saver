import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import '../../../core/models/status_file.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';
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
        content: Row(
          children: [
            Icon(
              saved ? Icons.check_circle_rounded : Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              saved ? 'Saved to gallery!' : 'Failed to save',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: saved ? AppColors.mint : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareStatus() async {
    await Share.shareXFiles([XFile(_currentStatus.path)]);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media viewer
          GestureDetector(
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

          // Top bar: progress indicators + close + download
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(160),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Story-style progress bars
                    if (widget.statuses.length > 1)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: Row(
                          children: List.generate(widget.statuses.length, (i) {
                            return Expanded(
                              child: Container(
                                height: 2.5,
                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                decoration: BoxDecoration(
                                  color: i <= _currentIndex
                                      ? AppColors.mint
                                      : Colors.white.withAlpha(60),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    // Close + Download
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
                          ),
                          IconButton(
                            onPressed: _saveStatus,
                            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 26),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Left/right tap navigation
          if (widget.statuses.length > 1) ...[
            Positioned(
              left: 0,
              top: 100,
              bottom: 160,
              width: 80,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (_currentIndex > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            Positioned(
              right: 0,
              top: 100,
              bottom: 160,
              width: 80,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (_currentIndex < widget.statuses.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],

          // Bottom actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withAlpha(200),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 24, 20, bottomPadding + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Save to Gallery button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mint,
                        foregroundColor: AppColors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _saveStatus,
                      icon: const Icon(Icons.download_rounded, size: 22),
                      label: const Text(
                        'Save to Gallery',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Share button
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withAlpha(50)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _shareStatus,
                            icon: const Icon(Icons.share_rounded, size: 18),
                            label: const Text('Share', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
