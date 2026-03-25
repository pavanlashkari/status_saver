import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/status_file.dart';
import 'status_tile.dart';

class StatusGrid extends StatelessWidget {
  final List<StatusFile> statuses;

  const StatusGrid({super.key, required this.statuses});

  @override
  Widget build(BuildContext context) {
    if (statuses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No statuses found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.gridSpacing),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppConstants.gridCrossAxisCount,
        crossAxisSpacing: AppConstants.gridSpacing,
        mainAxisSpacing: AppConstants.gridSpacing,
      ),
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        return StatusTile(
          status: statuses[index],
          onTap: () {
            context.push('/viewer', extra: {
              'statuses': statuses,
              'index': index,
            });
          },
        );
      },
    );
  }
}
