import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';

class HomeShellChatbot extends StatelessWidget {
  // 1. GoRouter에서 넘겨주는 하위 페이지(위젯)를 받습니다.
  final Widget child;

  const HomeShellChatbot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 현재 경로를 가져와서 어떤 아이콘을 활성화할지 결정합니다.
    final String location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0, // AppBar 경계선 제거
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            'Per-Log',
            style: AppTextStyles.headline28.copyWith(color: AppColors.mainFont),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.go(Routes.home), // 상단 홈 아이콘 클릭 시 홈 이동
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: AppColors.mainFont,
            ),
          ),
          const SizedBox(width: 17),
        ],
      ),
      // 2. 중요: 고정 텍스트가 아닌 GoRouter가 전달해준 child를 출력합니다.
      body: child,

      bottomNavigationBar: BottomAppBar(
        color: AppColors.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomItem(
              context,
              icon: Icons.home,
              label: '홈',
              route: Routes.home,
              isSelected: location == Routes.home, // 현재 경로와 일치하는지 확인
            ),
            _buildBottomItem(
              context,
              icon: Icons.splitscreen_outlined,
              label: '나의 일기',
              route: Routes.myDiary, // Routes에 diary 경로가 있다고 가정
              isSelected: location.startsWith(Routes.myDiary),
            ),
            _buildBottomItem(
              context,
              icon: Icons.settings,
              label: '설정',
              route: Routes.settings, // Routes에 settings 경로가 있다고 가정
              isSelected: location.startsWith(Routes.settings),
            ),
          ],
        ),
      ),
    );
  }

  // 아이템 빌더 함수 수정 (context와 route 추가)
  Widget _buildBottomItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => context.go(route), // 3. 클릭 시 해당 경로로 이동
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? AppColors.mainFont
                : AppColors.mainFont, // 선택 시 색상 변경
          ),
          Text(
            label,
            style: AppTextStyles.body11.copyWith(
              color: isSelected ? AppColors.mainFont : AppColors.mainFont,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
