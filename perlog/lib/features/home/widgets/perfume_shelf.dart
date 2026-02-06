import 'package:flutter/material.dart';
import 'package:perlog/features/home/widgets/shelf_row.dart';

class PerfumeShelf extends StatelessWidget {
  const PerfumeShelf({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return AspectRatio(
          aspectRatio: 362 / 371,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/perfume_shelf.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),

              const ShelfRow(
                y: 0.125,
                colors: [Colors.blue, Colors.green, Colors.orange],
              ),

              const ShelfRow(
                y: 0.415,
                colors: [Colors.orange, Colors.orange, Colors.green],
              ),

              const ShelfRow(
                y: 0.705,
                colors: [Colors.orange, Colors.red, Colors.yellow],
              ),
            ],
          ),
        );
      },
    );
  }
}
