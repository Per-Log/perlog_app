import 'package:flutter/material.dart';

class UploadPreview extends StatelessWidget {
  const UploadPreview({
    super.key,
    required this.imageProvider,
    required this.imageWidth,
    required this.imageHeight,
    this.borderRadius = 10,
  });

  final ImageProvider imageProvider;
  final double imageWidth;
  final double imageHeight;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerRatio = constraints.maxWidth / constraints.maxHeight;
        final imageRatio = imageWidth / imageHeight;

        double horizontalPadding = 0;
        double verticalPadding = 0;

        if (imageRatio > containerRatio) {
          final scaledHeight = constraints.maxWidth / imageRatio;
          verticalPadding = (constraints.maxHeight - scaledHeight) / 2;
        } else {
          final scaledWidth = constraints.maxHeight * imageRatio;
          horizontalPadding = (constraints.maxWidth - scaledWidth) / 2;
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Image(
              image: imageProvider,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      },
    );
  }
}
