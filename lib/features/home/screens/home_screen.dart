import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/file_service.dart';
import '../../../core/services/thumbnail_service.dart';
import '../bloc/status_bloc.dart';
import '../widgets/status_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatusBloc(fileService: FileService())..add(StatusLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _thumbnailService = ThumbnailService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Status Saver'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_outline),
              onPressed: () => context.push('/saved'),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Images'),
              Tab(text: 'Videos'),
            ],
          ),
        ),
        body: BlocConsumer<StatusBloc, StatusState>(
          listener: (context, state) {
            if (state is StatusLoaded) {
              _generateVideoThumbnails(state);
            }
          },
          builder: (context, state) {
            if (state is StatusLoading || state is StatusInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StatusError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is StatusEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported_outlined, size: 64),
                    SizedBox(height: 16),
                    Text('No statuses found'),
                    SizedBox(height: 8),
                    Text('Open WhatsApp and view some statuses'),
                  ],
                ),
              );
            }
            final loaded = state as StatusLoaded;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<StatusBloc>().add(StatusRefreshRequested());
              },
              child: TabBarView(
                children: [
                  StatusGrid(statuses: loaded.images),
                  StatusGrid(statuses: loaded.videos),
                ],
              ),
            );
          },
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
