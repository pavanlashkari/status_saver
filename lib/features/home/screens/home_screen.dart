import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/file_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/thumbnail_service.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/status_bloc.dart';
import '../widgets/status_grid.dart';
import '../../saved/bloc/saved_bloc.dart';
import '../../saved/screens/saved_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../ads/widgets/ad_banner_placeholder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => StatusBloc(fileService: FileService())..add(StatusLoadRequested()),
        ),
        BlocProvider(
          create: (_) => SavedBloc(storageService: StorageService())..add(SavedLoadRequested()),
        ),
      ],
      child: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mint = theme.primaryColor;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: const [
                _StatusPage(),
                SavedPage(),
                SettingsScreen(),
              ],
            ),
          ),
          if (_currentIndex == 0 || _currentIndex == 1)
            const AdBannerWidget(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.cardBorder : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.visibility_outlined,
                  activeIcon: Icons.visibility,
                  label: 'Status',
                  isActive: _currentIndex == 0,
                  mint: mint,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.check_circle_outline,
                  activeIcon: Icons.check_circle,
                  label: 'Saved',
                  isActive: _currentIndex == 1,
                  mint: mint,
                  onTap: () {
                    context.read<SavedBloc>().add(SavedLoadRequested());
                    setState(() => _currentIndex = 1);
                  },
                ),
                _NavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  isActive: _currentIndex == 2,
                  mint: mint,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color mint;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.mint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? mint.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: isActive
                  ? mint
                  : (isDark ? AppColors.textMuted : AppColors.lightTextSecondary),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: mint,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusPage extends StatefulWidget {
  const _StatusPage();

  @override
  State<_StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<_StatusPage> with SingleTickerProviderStateMixin {
  final _thumbnailService = ThumbnailService();
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
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                children: [
                  // App icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: mint.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.download_rounded, color: mint, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          AppConstants.appSubtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Refresh button
                  IconButton(
                    onPressed: () {
                      context.read<StatusBloc>().add(StatusRefreshRequested());
                    },
                    icon: Icon(Icons.refresh_rounded, color: mint),
                    tooltip: 'Refresh',
                  ),
                  // Menu
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    ),
                    color: isDark ? AppColors.surfaceLight : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {},
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'about', child: Text('About')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lightSurfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: isDark ? AppColors.background : Colors.white,
                  unselectedLabelColor: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: const TextStyle(fontSize: 14),
                  dividerColor: Colors.transparent,
                  splashBorderRadius: BorderRadius.circular(10),
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
              child: BlocConsumer<StatusBloc, StatusState>(
                listener: (context, state) {
                  if (state is StatusLoaded) {
                    _generateVideoThumbnails(state);
                  }
                },
                builder: (context, state) {
                  if (state is StatusLoading || state is StatusInitial) {
                    return Center(
                      child: CircularProgressIndicator(color: mint),
                    );
                  }
                  if (state is StatusError) {
                    return _buildErrorState(context, state.message);
                  }
                  if (state is StatusEmpty) {
                    return _buildEmptyState(context);
                  }
                  final loaded = state as StatusLoaded;
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      RefreshIndicator(
                        color: mint,
                        backgroundColor: isDark ? AppColors.surface : Colors.white,
                        onRefresh: () async {
                          context.read<StatusBloc>().add(StatusRefreshRequested());
                        },
                        child: StatusGrid(
                          statuses: loaded.images,
                          sectionTitle: 'Recent Updates',
                          badgeText: '${loaded.images.length} images',
                        ),
                      ),
                      RefreshIndicator(
                        color: mint,
                        backgroundColor: isDark ? AppColors.surface : Colors.white,
                        onRefresh: () async {
                          context.read<StatusBloc>().add(StatusRefreshRequested());
                        },
                        child: StatusGrid(
                          statuses: loaded.videos,
                          sectionTitle: 'Recent Updates',
                          badgeText: '${loaded.videos.length} videos',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<StatusBloc, StatusState>(
        builder: (context, state) {
          if (state is! StatusLoaded) return const SizedBox.shrink();
          return FloatingActionButton(
            backgroundColor: mint,
            foregroundColor: isDark ? AppColors.background : Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () {
              context.read<StatusBloc>().add(StatusRefreshRequested());
            },
            child: const Icon(Icons.refresh_rounded, size: 26),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final mint = theme.primaryColor;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
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
              child: Icon(Icons.photo_library_outlined, size: 36, color: mint),
            ),
            const SizedBox(height: 24),
            Text(
              'No statuses found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Open WhatsApp, view some statuses,\nthen come back and tap refresh',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.outline,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: mint,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  context.read<StatusBloc>().add(StatusRefreshRequested());
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Refresh', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 56, color: AppColors.danger),
            const SizedBox(height: 16),
            Text('Something went wrong',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: theme.colorScheme.outline)),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.read<StatusBloc>().add(StatusLoadRequested()),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateVideoThumbnails(StatusLoaded state) async {
    for (final video in state.videos) {
      if (video.thumbnailPath != null) continue;
      final thumb = await _thumbnailService.generateThumbnail(video.path);
      if (thumb != null && mounted) {
        setState(() => video.thumbnailPath = thumb);
      }
    }
  }
}
