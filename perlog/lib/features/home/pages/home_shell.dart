import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/router/routes.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 1. 현재 경로 파악
    final String location = GoRouterState.of(context).uri.path;

    // 2. 활성화 상태 정의
    final bool isHomeActive = location == Routes.home;
    final bool isDiaryActive = location.startsWith(Routes.myDiaryMain);
    final bool isSettingsActive = location == Routes.settings;

    // 3. 현재 경로에 따른 타이틀 설정
    String appBarTitle = 'Per-Log';
    if (isDiaryActive) appBarTitle = '나의 일기';
    if (isSettingsActive) appBarTitle = '설정';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false, // 왼쪽 정렬 유지
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            appBarTitle,
            style: AppTextStyles.headline28.copyWith(color: AppColors.mainFont),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go(Routes.chatbot),
            icon: Image.asset(
              'assets/icons/chatbot.png',
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 17),
        ],
      ),
      body: child, // 내부 콘텐츠가 교체되는 영역
      bottomNavigationBar: BottomAppBar(
        color: AppColors.background,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomItem(
              context,
              icon: isHomeActive ? Icons.home : Icons.home_outlined,
              label: '홈',
              route: Routes.home,
              isActive: isHomeActive,
            ),
            _buildBottomItem(
              context,
              icon: isDiaryActive ? Icons.book : Icons.book_outlined,
              label: '나의 일기',
              route: Routes.myDiaryMain,
              isActive: isDiaryActive,
            ),
            _buildBottomItem(
              context,
              icon: isSettingsActive ? Icons.settings : Icons.settings_outlined,
              label: '설정',
              route: Routes.settings,
              isActive: isSettingsActive,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    final Color itemColor = isActive
        ? AppColors.mainFont
        : AppColors.mainFont.withOpacity(0.5);

    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(10), // 클릭 피드백 범위
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Icon(icon, color: itemColor, size: 28),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.body11.copyWith(
                color: itemColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
