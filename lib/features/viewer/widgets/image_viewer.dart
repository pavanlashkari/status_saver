import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/models/status_file.dart';

class ImageViewer extends StatelessWidget {
  final StatusFile status;

  const ImageViewer({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.file(
          File(status.path),
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image,
            color: Colors.white54,
            size: 64,
          ),
        ),
      ),
    );
  }
}
