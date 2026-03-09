import 'package:go_router/go_router.dart';
import 'package:perlog/core/router/custom_transition_page.dart';
import 'package:perlog/core/router/routes.dart';
import 'package:perlog/features/setting/pages/pages.dart';

final settingsRoutes = [

  GoRoute(
    path: '${Routes.settings}/${Routes.settingsProfile}',
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const ProfileEditPage(),
    ),
  ),

  GoRoute(
    path: '${Routes.settings}/${Routes.settingsPinCheck}',
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const PinCheckPage(),
    ),
  ),

  GoRoute(
    path: '${Routes.settings}/${Routes.settingsPinSet}',
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const PinSetPage(),
    ),
  ),

  GoRoute(
    path: '${Routes.settings}/${Routes.settingsPinConfirm}',
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const PinConfirmPage(),
    ),
  ),

  GoRoute(
    path: '${Routes.settings}/${Routes.settingsTutorial}',
    pageBuilder: (context, state) => fadeTransitionPage(
      key: state.pageKey,
      child: const TutorialPage(),
    ),
  ),
];