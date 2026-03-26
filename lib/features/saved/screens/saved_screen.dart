import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import '../../../core/theme/app_theme.dart';
import '../../../core/models/status_file.dart';
import '../bloc/saved_bloc.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mint = theme.primaryColor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Collection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your downloaded statuses',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pill tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lightSurfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: isDark ? AppColors.background : Colors.white,
                  unselectedLabelColor: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.all(3),
                  tabs: const [
                    Tab(text: 'Images'),
                    Tab(text: 'Videos'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: BlocBuilder<SavedBloc, SavedState>(
                builder: (context, state) {
                  if (state is SavedLoading || state is SavedInitial) {
                    return Center(child: CircularProgressIndicator(color: mint));
                  }
                  if (state is SavedEmpty) {
                    return _buildEmptyState(context);
                  }
                  final loaded = state as SavedLoaded;
                  final images = loaded.statuses.where((s) => s.isImage).toList();
                  final videos = loaded.statuses.where((s) => s.isVideo).toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGrid(context, images),
                      _buildGrid(context, videos),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final mint = theme.primaryColor;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: mint.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bookmark_outline_rounded, size: 36, color: mint),
          ),
          const SizedBox(height: 20),
          Text(
            'No saved statuses yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Saved statuses will appear here',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<StatusFile> statuses) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (statuses.isEmpty) {
      return Center(
        child: Text(
          'Nothing here yet',
          style: TextStyle(fontSize: 14, color: theme.colorScheme.outline),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        final status = statuses[index];
        return GestureDetector(
          onTap: () => context.push('/viewer', extra: {
            'statuses': statuses,
            'index': index,
          }),
          onLongPress: () => _showActions(context, status),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.cardBorder : Colors.grey.shade200,
                width: 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(status.path),
                    fit: BoxFit.cover,
                    cacheWidth: 400,
                    errorBuilder: (_, __, ___) => Container(
                      color: isDark ? AppColors.surface : AppColors.lightSurfaceAlt,
                      child: const Icon(Icons.image_outlined, color: Colors.grey),
                    ),
                  ),
                  if (status.isVideo)
                    Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(90),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
                      ),
                    ),
                  // Bottom actions
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withAlpha(160),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _MiniButton(
                            icon: Icons.share_rounded,
                            onTap: () => Share.shareXFiles([XFile(status.path)]),
                          ),
                          const SizedBox(width: 4),
                          _MiniButton(
                            icon: Icons.delete_outline_rounded,
                            onTap: () {
                              context.read<SavedBloc>().add(SavedDeleteRequested(status));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showActions(BuildContext context, StatusFile status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.textMuted : Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                Share.shareXFiles([XFile(status.path)]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
              title: const Text('Delete', style: TextStyle(color: AppColors.danger)),
              onTap: () {
                Navigator.pop(context);
                context.read<SavedBloc>().add(SavedDeleteRequested(status));
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(60),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
