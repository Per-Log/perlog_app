import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:perlog/core/router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. main 함수를 async로 변경
void main() async {  // 2. 비동기 처리를 위해 플러터 엔진 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");


  // 3. 한국어(ko_KR) 날짜 데이터가 로드될 때까지 기다림
  await initializeDateFormatting('ko_KR', null);

  await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"),
    anonKey: dotenv.get("SUPABASE_ANON_KEY"),
  );

  KakaoSdk.init(
    nativeAppKey: dotenv.get("KAKAO_NATIVE_APP_KEY"),
    javaScriptAppKey: dotenv.get("KAKAO_JAVASCRIPT_APP_KEY"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}