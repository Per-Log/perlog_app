import 'package:flutter/material.dart';

class MetadataImagePreviewButton extends StatelessWidget {
  const MetadataImagePreviewButton({
    required this.onPressed,
    required this.imageUrl,
    this.showImage = true,
    super.key,
  });

  final VoidCallback onPressed;
  final String? imageUrl;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox.expand(
            child: (showImage && imageUrl != null)
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('이미지를 불러오지 못했습니다.'));
                    },
                  )
                : const Center(child: Text('이미지 업로드')),
          ),
        ),
      ),
    );
  }
}
