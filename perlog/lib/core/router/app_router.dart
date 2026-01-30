import 'package:go_router/go_router.dart';
import 'package:perlog/core/constants/spacing_test_page.dart';
import 'package:perlog/features/home/home_shell.dart';
import 'package:perlog/features/main/chatbot/chatbot_page.dart';
import 'package:perlog/features/main/metadata/image_upload_edit.dart';
import 'package:perlog/features/main/metadata/image_upload_finished_page.dart';
import 'package:perlog/features/main/metadata/image_upload_page.dart';
import 'package:perlog/features/main/metadata/calendar_page.dart';
import 'package:perlog/features/main/metadata/ocr_loading_page.dart';
import 'package:perlog/features/main/metadata/sentiment_analysis_page.dart';
import 'package:perlog/features/main/perfume_selected/perfume_selected.dart';
import 'package:perlog/features/main/perfume_shelf_page.dart';
import 'package:perlog/features/mydiary/my_analysis_page.dart';
import 'package:perlog/features/mydiary/my_calendar_page.dart';
import 'package:perlog/features/mydiary/my_diary_page.dart';
import 'package:perlog/features/onboarding/pages/kakao_login_page.dart';
import 'package:perlog/features/onboarding/pages/onboarding_profile_page.dart';
import 'package:perlog/features/onboarding/pages/pin_confirm_page.dart';
import 'package:perlog/features/onboarding/pages/pin_set_page.dart';
import 'package:perlog/features/setting/setting_page.dart';
import 'package:perlog/features/splash/splash_page.dart';
import 'routes.dart';

bool isOnboarded = true;

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    /// Splash
    GoRoute(path: Routes.splash, builder: (_, __) => const SplashPage()),

    /// Kakao Login
    GoRoute(
      path: Routes.login,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: KakaoLoginPage()),
    ),

    /// Onboarding Flow
    GoRoute(
      path: Routes.onboarding,
      redirect: (context, state) {
        if (state.uri.toString() == Routes.onboarding) {
          return '${Routes.onboarding}/${Routes.profile}';
        }
        return null;
      },
      routes: [
        /// 이미지 / 별명 / 알림 / 잠금
        GoRoute(
          path: Routes.profile,
          builder: (_, __) => const OnboardingProfilePage(),
        ),

        /// PIN 설정
        GoRoute(path: Routes.pinSet, builder: (_, __) => const PinSetPage()),

        /// PIN 확인
        GoRoute(
          path: Routes.pinConfirm,
          builder: (_, __) => const PinConfirmPage(),
        ),
      ],
    ),

    /// Onboarding 완료 후 진입
    GoRoute(path: Routes.shell, builder: (_, __) => const HomeShell()),

    /// Settings
    GoRoute(path: Routes.settings, builder: (_, __) => const Settings()),

    /// Main
    GoRoute(
      path: Routes.perfumeShelf,
      builder: (_, __) => const PerfumeShelf(),
    ),
    GoRoute(
      path: Routes.perfumeSelected,
      builder: (_, __) => const PerfumeSelected(),
    ),

    /// Chatbot
    GoRoute(path: Routes.chatbot, builder: (_, __) => const Chatbot()),

    /// Metadata Flow
    GoRoute(
      path: Routes.metadata,
      redirect: (context, state) {
        if (state.uri.toString() == Routes.metadata) {
          return '${Routes.metadata}/${Routes.calendar}';
        } else {
          null;
        }
      },
      routes: [
        /// 날짜 선택
        GoRoute(path: Routes.calendar, builder: (_, __) => const Calendar()),

        /// 이미지 업로드
        GoRoute(
          path: Routes.imageUpload,
          builder: (_, __) => const ImageUpload(),
        ),

        /// 이미지 업로드 (완료)
        GoRoute(
          path: Routes.imageUploadFinished,
          builder: (_, __) => const ImageUploadFinished(),
        ),

        /// 이미지 업로드 수정사항
        GoRoute(
          path: Routes.imageUploadEdit,
          builder: (_, __) => const ImageUploadEdit(),
        ),

        /// OCR Loading
        GoRoute(
          path: Routes.ocrLoading,
          builder: (_, __) => const OCRLoading(),
        ),

        GoRoute(
          path: Routes.diaryAnalysis,
          builder: (_, __) => const DiaryAnalysis(),
        ),
      ],
    ),

    /// MyDiary Flow
    GoRoute(
      path: Routes.myDiaryMain,
      redirect: (context, state) {
        if (state.uri.toString() == Routes.myDiaryMain) {
          return '${Routes.myDiaryMain}/${Routes.myDiary}';
        } else {
          null;
        }
      },
      routes: [
        /// 날짜 선택
        GoRoute(path: Routes.myDiary, builder: (_, __) => const MyDiary()),

        /// 이미지 업로드
        GoRoute(
          path: Routes.myAnalysis,
          builder: (_, __) => const MyAnalysis(),
        ),

        /// 이미지 업로드 (완료)
        GoRoute(
          path: Routes.myCalendar,
          builder: (_, __) => const MyCalendar(),
        ),
      ],
    ),

    ////// debug
    GoRoute(
      path: Routes.paddingTest,
      builder: (_, __) => const PaddingTestPage(),
    ),
  ],
);
