import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/models/status_file.dart';
import '../../../core/theme/app_theme.dart';

class StatusTile extends StatelessWidget {
  final StatusFile status;
  final VoidCallback onTap;
  final bool isNew;

  const StatusTile({
    super.key,
    required this.status,
    required this.onTap,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: status.path,
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
                _buildThumbnail(context),

                // Top gradient for NEW badge
                if (isNew)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha(80),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // NEW dot indicator
                if (isNew)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.mint,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                // Bottom gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withAlpha(140),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Video indicator
                if (status.isVideo) ...[
                  Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(90),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withAlpha(50), width: 1),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        const Icon(Icons.videocam_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Video',
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (status.isImage) {
      return Image.file(
        File(status.path),
        fit: BoxFit.cover,
        cacheWidth: 400,
        errorBuilder: (_, __, ___) => _PlaceholderTile(),
      );
    }
    if (status.thumbnailPath != null) {
      return Image.file(
        File(status.thumbnailPath!),
        fit: BoxFit.cover,
        cacheWidth: 400,
        errorBuilder: (_, __, ___) => _PlaceholderTile(),
      );
    }
    return _PlaceholderTile();
  }
}

class _PlaceholderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.surface : AppColors.lightSurfaceAlt,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 32,
          color: isDark ? AppColors.textMuted : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
