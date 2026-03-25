import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/models/status_file.dart';

class StatusTile extends StatelessWidget {
  final StatusFile status;
  final VoidCallback onTap;

  const StatusTile({super.key, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: status.path,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildThumbnail(),
              if (status.isVideo)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(128),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (status.isImage) {
      return Image.file(
        File(status.path),
        fit: BoxFit.cover,
        cacheWidth: 300,
        errorBuilder: (_, __, ___) => const _PlaceholderTile(),
      );
    }
    if (status.thumbnailPath != null) {
      return Image.file(
        File(status.thumbnailPath!),
        fit: BoxFit.cover,
        cacheWidth: 300,
        errorBuilder: (_, __, ___) => const _PlaceholderTile(),
      );
    }
    return const _PlaceholderTile();
  }
}

class _PlaceholderTile extends StatelessWidget {
  const _PlaceholderTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.image_outlined, size: 32),
    );
  }
}
