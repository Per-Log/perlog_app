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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 21,
        
        title: Text(
          'Per-Log',
          style: AppTextStyles.headline28.copyWith(
            color: AppColors.mainFont,
          ),
        ),

        actionsPadding: const EdgeInsets.only(right: 5),

        actions: [
          IconButton(
            onPressed: () => context.go(Routes.chatbot),
            icon: Image.asset(
              'assets/icons/chatbot.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),

      body: child, // 내부 콘텐츠가 교체되는 영역

      bottomNavigationBar: BottomAppBar(
        color: AppColors.background,
        elevation: 0,
        child: Row(
          children: [
            const Spacer(flex: 2),
            _buildBottomItem(
              context,
              assetPath: isHomeActive
                  ? 'assets/icons/filled_home.png'
                  : 'assets/icons/line_home.png',
              label: '홈',
              route: Routes.home,
              isActive: isHomeActive,
            ),
            const Spacer(flex: 5),
            _buildBottomItem(
              context,
              assetPath: isDiaryActive
                  ? 'assets/icons/filled_diary.png'
                  : 'assets/icons/line_diary.png',
              label: '나의 일기',
              route: Routes.myDiaryMain,
              isActive: isDiaryActive,
            ),
            const Spacer(flex: 5),
            _buildBottomItem(
              context,
              assetPath: isSettingsActive
                  ? 'assets/icons/filled_setting.png'
                  : 'assets/icons/line_setting.png',
              label: '설정',
              route: Routes.settings,
              isActive: isSettingsActive,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem(
  BuildContext context, {
  required String assetPath,
  required String label,
  required String route,
  required bool isActive,
}) {
  final Color itemColor =
      isActive ? AppColors.mainFont : AppColors.subFont;

  return InkWell(
    onTap: () => context.go(route),
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            assetPath,
            width: 28,
            height: 28, 
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.body12.copyWith(
              color: itemColor,
            ),
          ),
        ],
      ),
    ),
  );
}

}
