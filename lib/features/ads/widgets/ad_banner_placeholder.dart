import 'package:flutter/material.dart';

class AdBannerPlaceholder extends StatelessWidget {
  const AdBannerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Text('Ad Space', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
