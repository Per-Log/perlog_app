import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';


// 1. main 함수를 async로 변경
Future<void> main() async {
  // 2. 비동기 처리를 위해 플러터 엔진 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // 3. 한국어(ko_KR) 날짜 데이터가 로드될 때까지 기다림
  await initializeDateFormatting('ko_KR', null);
  
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

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
