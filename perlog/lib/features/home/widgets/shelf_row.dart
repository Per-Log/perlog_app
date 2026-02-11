import 'package:flutter/material.dart';
import 'package:perlog/features/home/widgets/perfume_detail_dialog.dart';
import 'package:perlog/features/home/widgets/perfume_icon.dart';

class ShelfRow extends StatelessWidget {
  final double y;
  final List<Color> colors;

  const ShelfRow({
    super.key,
    required this.y,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    const xs = [0.23, 0.5, 0.77];

    return Stack(
      children: List.generate(3, (i) {
        return Align(
          alignment: FractionalOffset(xs[i], y),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (_) => PerfumeDetailDialog(color: colors[i]),
              );
            },
            child: PerfumeIcon(
              color: colors[i],
            ),
          ),
        );
      }),
    );
  }
}
