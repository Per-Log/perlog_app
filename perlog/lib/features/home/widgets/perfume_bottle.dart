import 'package:flutter/material.dart';

class PerfumeBottle extends StatelessWidget {
  final Color color;

  const PerfumeBottle({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,   // 🔥 병 기준 크기 (고정)
      height: 52,  // 🔥 정사각 캔버스
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 6,   // ← 실제 병 안쪽에 맞춘 값
            right: 6,
            bottom: 1, // ← 중요: 중앙이 아니라 bottom 기준
            child: Image.asset(
              'assets/icons/perfume_color.png',
              color: color,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 1. 병 외곽 (기준)
          Positioned.fill(
            child: Image.asset(
              'assets/icons/line_perfume.png',
              fit: BoxFit.contain,
            ),
          ),

          /// 2. 병 내용물 (🔥 위치 고정)

        ],
      ),
    );
  }
}
