// 향수 선택 시 별도 페이지가 아닌 호버링 위젯으로 처리하는게 좋을 듯해서 주석처리 후 디렉토리 이동해둡니다!
// 기존 perlog/lib/features/main/perfume_selected
// 이동 후 perlog/lib/features/main/widgets/perfume_detail_dialog.dart
// 라우터 내 코드도 삭제 처리하였습니다!

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:perlog/core/constants/colors.dart';
// import 'package:perlog/core/constants/text_styles.dart';
// import 'package:perlog/core/constants/spacing.dart';
// import 'package:perlog/core/router/routes.dart';

// class PerfumeSelected extends StatelessWidget {
//   const PerfumeSelected({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Text(
//                 'Main-향수선택 page',
//                 style: AppTextStyles.headline50.copyWith(
//                   color: AppColors.mainFont,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
