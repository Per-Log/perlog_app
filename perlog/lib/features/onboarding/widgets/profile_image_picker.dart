import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';

class ProfileImagePicker extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileImagePicker({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// 프로필 원
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.mainFont,
                    width: 3,
                  ),
                ),
              ),

              /// 카메라 버튼
              Positioned(
                right: 180 * 0.1,
                bottom: 180 * 0.01,
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
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
