import 'package:perlog/domain/auth/auth_service.dart';
import 'package:perlog/domain/onboarding/onboarding_service.dart';
import 'package:perlog/domain/lock/lock_service.dart';
import 'package:perlog/core/storage/pref/pref_keys.dart';
import 'package:perlog/core/storage/pref/pref_service.dart';
import 'app_route_result.dart';

class AppStartService {
  AppStartService._();

  static Future<AppRouteResult> getInitialRoute() async {
    // 병렬 실행
    final results = await Future.wait([
      AuthService.isLoggedIn(),
      OnboardingService.isProfileCompleted(),
      LockService.shouldLock(),
      PrefService.getBool(PrefKeys.isFirstLaunch),
    ]);

    final isLoggedIn = results[0] as bool;
    final isProfileCompleted = results[1] as bool;
    final shouldLock = results[2] as bool;
    final firstLaunchValue = results[3] as bool?;

    /// 최초 실행 처리
    final isFirstLaunch = firstLaunchValue == null;
    if (isFirstLaunch) {
      await PrefService.setBool(PrefKeys.isFirstLaunch, false);
    }

    print('====== AppStart ======');
    print('isLoggedIn: $isLoggedIn');
    print('isFirstLaunch: $isFirstLaunch');
    print('isProfileCompleted: $isProfileCompleted');
    print('shouldLock: $shouldLock');
    print('======================');

    /// 1. 로그인
    if (!isLoggedIn) {
      return AppRouteResult.login;
    }

    /// 2. 온보딩
    if (isFirstLaunch || !isProfileCompleted) {
      return AppRouteResult.onboarding;
    }

    /// 3. 잠금
    if (shouldLock) {
      return AppRouteResult.pinCheck;
    }

    /// 4. 홈
    return AppRouteResult.home;
  }
}