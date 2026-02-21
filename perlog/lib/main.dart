import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:perlog/core/router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. main 함수를 async로 변경
void main() async {  // 2. 비동기 처리를 위해 플러터 엔진 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // 3. 한국어(ko_KR) 날짜 데이터가 로드될 때까지 기다림
  await initializeDateFormatting('ko_KR', null);

  await Supabase.initialize(
    url: 'https://uzpfybxalroyynjhbfis.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV6cGZ5YnhhbHJveXluamhiZmlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE2NDM0OTYsImV4cCI6MjA4NzIxOTQ5Nn0.Sx4tsDJe30WNQz-u4QLoI4nwRrRtpJp9WDLVbQEK12s',
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
