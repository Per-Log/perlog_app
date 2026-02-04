import 'package:flutter/widgets.dart';

class DiaryBubbleItem extends StatelessWidget {
  final bool active;

  const DiaryBubbleItem({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      active
          ? 'assets/icons/filled_bubble.png'
          : 'assets/icons/line_bubble.png',
      width: 32,
      height: 32,
    );
  }
}
