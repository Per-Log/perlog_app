import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';

class ProfileImagePicker extends StatelessWidget {
  final VoidCallback? onTap;
  final ImageProvider? imageProvider;
  final bool isUploading;

  const ProfileImagePicker({
    super.key,
    this.onTap,
    this.imageProvider,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 원형 이미지 영역
            ClipOval(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.mainFont,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// 이미지
                    if (imageProvider != null)
                      Image(
                        image: imageProvider!,
                        fit: BoxFit.contain,
                      ),

                    /// 이미지 없을 때 기본 카메라
                    if (imageProvider == null && !isUploading)
                      Center(
                        child: Image.asset(
                          'assets/icons/camera.png',
                          width: 40,
                          height: 40,
                          color: AppColors.subFont,
                        ),
                      ),

                    /// 업로드 중
                    if (isUploading)
                      const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
            ),

            /// 오른쪽 아래 작은 카메라 버튼
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.subBackground,
                  border: Border.all(
                    color: AppColors.mainFont,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/camera.png',
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}