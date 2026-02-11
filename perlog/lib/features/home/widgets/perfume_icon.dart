import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PerfumeIcon extends StatelessWidget {
  final Color color;
  final double size;

  const PerfumeIcon({
    super.key,
    required this.color,
    this.size = 52, // TODO: mediaquery
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/perfume_color.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),

          Image.asset(
            'assets/icons/perfume_frame.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
