import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import '../../../core/constants/app_constants.dart';
import '../../../core/models/status_file.dart';
import '../../../core/services/storage_service.dart';
import '../bloc/saved_bloc.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavedBloc(storageService: StorageService())..add(SavedLoadRequested()),
      child: const _SavedView(),
    );
  }
}

class _SavedView extends StatelessWidget {
  const _SavedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: BlocBuilder<SavedBloc, SavedState>(
        builder: (context, state) {
          if (state is SavedLoading || state is SavedInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SavedEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64),
                  SizedBox(height: 16),
                  Text('No saved statuses yet'),
                ],
              ),
            );
          }
          final loaded = state as SavedLoaded;
          return GridView.builder(
            padding: const EdgeInsets.all(AppConstants.gridSpacing),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppConstants.gridCrossAxisCount,
              crossAxisSpacing: AppConstants.gridSpacing,
              mainAxisSpacing: AppConstants.gridSpacing,
            ),
            itemCount: loaded.statuses.length,
            itemBuilder: (context, index) {
              final status = loaded.statuses[index];
              return GestureDetector(
                onTap: () => context.push('/viewer', extra: {
                  'statuses': loaded.statuses,
                  'index': index,
                }),
                onLongPress: () => _showActions(context, status),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(status.path),
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                        errorBuilder: (_, __, ___) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image_outlined),
                        ),
                      ),
                      if (status.isVideo)
                        const Center(
                          child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showActions(BuildContext context, StatusFile status) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                Share.shareXFiles([XFile(status.path)]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                context.read<SavedBloc>().add(SavedDeleteRequested(status));
              },
            ),
          ],
        ),
      ),
    );
  }
}
